import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders })
    }

    try {
        const authHeader = req.headers.get('Authorization')
        if (!authHeader) {
            return new Response(JSON.stringify({ error: 'Missing Authorization header' }), {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                status: 401,
            })
        }

        const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
        const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
        const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY') ?? ''

        // Create a user client to verify the token
        const userClient = createClient(supabaseUrl, supabaseAnonKey, {
            global: { headers: { Authorization: authHeader } }
        })

        const { data: { user }, error: userError } = await userClient.auth.getUser()

        if (userError || !user) {
            console.error('Auth verification failed:', userError)
            return new Response(JSON.stringify({ error: 'Unauthorized: Invalid token' }), {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                status: 401,
            })
        }

        const callerId = user.id

        // Create service client for admin tasks
        const supabaseClient = createClient(supabaseUrl, supabaseServiceKey)

        // Fetch authoritative role from DB
        const { data: roleData, error: roleError } = await supabaseClient
            .from('user_roles')
            .select('role')
            .eq('id', callerId)
            .single()

        if (roleError || !roleData) {
            console.error('Failed to fetch caller role:', roleError)
            return new Response(JSON.stringify({ error: 'Unauthorized: Role not found' }), {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                status: 403,
            })
        }

        const callerRole = roleData.role


        const requestData = await req.json()
        console.log('--- Edge Function Request ---')
        console.log(`Action: ${requestData.action}`)
        console.log(`Caller: ${callerId} (${callerRole})`)
        console.log('Payload:', JSON.stringify(requestData, null, 2))

        const { action, userId, role, email, password, metadata, applicationData, applicationId, passportBase64, signatureBase64, warehouseId, note, active } = requestData

        async function uploadAsset(userId: string, type: 'passport' | 'signature', base64: string) {
            const isPng = base64.startsWith('data:image/png') || base64.length < 1000;
            const ext = isPng ? 'png' : 'jpg';
            const path = `${userId}/${type}_${Date.now()}.${ext}`;

            // Remove the data URL prefix if it exists
            const base64Data = base64.includes(',') ? base64.split(',')[1] : base64;
            const binaryData = Uint8Array.from(atob(base64Data), c => c.charCodeAt(0));

            const { data, error } = await supabaseClient.storage
                .from('uploads')
                .upload(path, binaryData, {
                    contentType: isPng ? 'image/png' : 'image/jpeg',
                    upsert: true
                });

            if (error) throw error;
            return data.path;
        }

        if (action === 'create_user') {
            const targetRole = role ?? 'farmer'
            const isAuthorized = callerRole === 'super_admin' ||
                (callerRole === 'admin' && (targetRole === 'admin' || targetRole === 'agent' || targetRole === 'farmer' || targetRole === 'warehouse_manager'));

            if (!isAuthorized) {
                return new Response(JSON.stringify({ error: 'Unauthorized role creation' }), {
                    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                    status: 403,
                })
            }

            const { data: authData, error: authError } = await supabaseClient.auth.admin.createUser({
                email,
                password,
                email_confirm: true,
                user_metadata: { ...metadata, role: targetRole },
            })

            if (authError) throw authError

            const { error: roleError } = await supabaseClient
                .from('user_roles')
                .upsert({ id: authData.user.id, role: targetRole, active: true })

            if (roleError) throw roleError

            const { error: profileError } = await supabaseClient
                .from('profiles')
                .upsert({
                    id: authData.user.id,
                    email: email,
                    first_name: metadata?.first_name,
                    last_name: metadata?.last_name,
                })

            if (profileError) throw profileError

            return new Response(JSON.stringify({ user: authData.user }), {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                status: 201,
            })
        }

        if (action === 'agent_create_farmer_application') {
            console.log(`[agent_create_farmer_application] Starting for email: ${email}`);
            if (callerRole !== 'super_admin' && callerRole !== 'admin' && callerRole !== 'agent') {
                console.error(`[agent_create_farmer_application] Unauthorized: Caller role ${callerRole} is not allowed.`);
                return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 403, headers: corsHeaders });
            }

            console.log(`[agent_create_farmer_application] Listing users to check if ${email} exists...`);
            const { data: existingUsersData, error: listUsersError } = await supabaseClient.auth.admin.listUsers();
            if (listUsersError) {
                console.error(`[agent_create_farmer_application] Error listing users:`, listUsersError);
                throw listUsersError;
            }

            const user = existingUsersData.users.find((u: any) => u.email === email);

            let farmerId: string;
            if (user) {
                farmerId = user.id;
                console.log(`[agent_create_farmer_application] Found existing user: ${farmerId}. Checking for existing application...`);
                const { data: existingApp, error: checkAppError } = await supabaseClient
                    .from('applications')
                    .select('id')
                    .eq('user_id', farmerId)
                    .maybeSingle();

                if (checkAppError) {
                    console.error(`[agent_create_farmer_application] Error checking existing application:`, checkAppError);
                    throw checkAppError;
                }

                if (existingApp) {
                    console.warn(`[agent_create_farmer_application] User ${farmerId} already has an application: ${existingApp.id}`);
                    return new Response(JSON.stringify({ error: 'User already has an application' }), {
                        status: 400,
                        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
                    });
                }
            } else {
                console.log(`[agent_create_farmer_application] User not found. Inviting ${email}...`);
                const { data: inviteData, error: inviteError } = await supabaseClient.auth.admin.inviteUserByEmail(email, {
                    data: { ...metadata, role: 'farmer' }
                });
                if (inviteError) {
                    console.error(`[agent_create_farmer_application] Invite error:`, inviteError);
                    throw inviteError;
                }
                farmerId = inviteData.user.id;
                console.log(`[agent_create_farmer_application] Invited successfully. Assigned ID: ${farmerId}. Setting user role...`);
                const { error: roleError } = await supabaseClient
                    .from('user_roles')
                    .upsert({ id: farmerId, role: 'farmer', active: true });
                if (roleError) {
                    console.error(`[agent_create_farmer_application] Error setting user role:`, roleError);
                    throw roleError;
                }
            }

            // Always upsert profile for the farmer
            console.log(`[agent_create_farmer_application] Upserting profile for farmer ${farmerId}...`);
            const { error: profileError } = await supabaseClient
                .from('profiles')
                .upsert({
                    id: farmerId,
                    email: email,
                    first_name: metadata?.first_name,
                    last_name: metadata?.last_name,
                })
            if (profileError) {
                console.error(`[agent_create_farmer_application] Profile upsert error:`, profileError);
                throw profileError;
            }

            let passportPath = null;
            let signaturePath = null;
            if (passportBase64) {
                console.log(`[agent_create_farmer_application] Uploading passport...`);
                passportPath = await uploadAsset(farmerId, 'passport', passportBase64);
            }
            if (signatureBase64) {
                console.log(`[agent_create_farmer_application] Uploading signature...`);
                signaturePath = await uploadAsset(farmerId, 'signature', signatureBase64);
            }

            console.log(`[agent_create_farmer_application] Inserting application data...`);
            const { data: appData, error: appError } = await supabaseClient
                .from('applications')
                .insert({
                    ...applicationData,
                    user_id: farmerId,
                    created_by: callerId,
                    status: 'initial',
                    passport_path: passportPath,
                    signature_path: signaturePath
                })
                .select()
                .single();

            if (appError) {
                console.error(`[agent_create_farmer_application] Application insert error:`, appError);
                throw appError;
            }

            console.log(`[agent_create_farmer_application] Application created successfully! ID: ${appData.id}`);
            return new Response(JSON.stringify({ user_id: farmerId, application: appData }), {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                status: 201,
            });
        }

        if (action === 'assign_warehouse') {
            console.log(`[assign_warehouse] Attempting for Application: ${applicationId}, Warehouse: ${warehouseId}`)
            if (callerRole !== 'super_admin' && callerRole !== 'admin') {
                console.error(`[assign_warehouse] Unauthorized attempt by role: ${callerRole}`)
                return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 403, headers: corsHeaders });
            }

            const { data, error } = await supabaseClient
                .from('farmer_designation')
                .upsert({
                    application: applicationId,
                    warehouse: warehouseId,
                    note: note
                }, {
                    onConflict: 'application'
                })
                .select()
                .single();

            if (error) {
                console.error(`[assign_warehouse] Database Error:`, JSON.stringify(error, null, 2))
                throw error;
            }

            console.log(`[assign_warehouse] Success:`, JSON.stringify(data, null, 2))
            return new Response(JSON.stringify({ data }), {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                status: 200,
            });
        }

        if (action === 'update_role') {
            if (callerRole !== 'super_admin' && callerRole !== 'admin') {
                return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 403, headers: corsHeaders });
            }

            // Update user_roles table
            const { data, error } = await supabaseClient
                .from('user_roles')
                .upsert({ id: userId, role })
                .select()

            if (error) throw error

            // Also update Auth metadata so it's reflected in JWT
            const { error: authError } = await supabaseClient.auth.admin.updateUserById(
                userId,
                { user_metadata: { role } }
            )
            if (authError) throw authError

            return new Response(JSON.stringify({ data }), {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                status: 200,
            })
        }

        if (action === 'toggle_user_status') {
            if (callerRole !== 'super_admin') {
                return new Response(JSON.stringify({ error: 'Only super_admin can toggle user status' }), {
                    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                    status: 403,
                })
            }

            const { data, error } = await supabaseClient
                .from('user_roles')
                .update({ active })
                .eq('id', userId)
                .select()
                .single()

            if (error) throw error

            return new Response(JSON.stringify({ data }), {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                status: 200,
            })
        }

        if (action === 'delete_user') {
            if (callerRole !== 'super_admin') {
                return new Response(JSON.stringify({ error: 'Only super_admin can delete users' }), {
                    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                    status: 403,
                })
            }
            const { error } = await supabaseClient.auth.admin.deleteUser(userId)
            if (error) throw error

            return new Response(JSON.stringify({ message: 'User deleted' }), {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                status: 200,
            })
        }

        return new Response(JSON.stringify({ error: 'Invalid action' }), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 400,
        })
    } catch (error: any) {
        console.error('--- Edge Function Error ---')
        console.error(error)
        return new Response(JSON.stringify({ error: error.message }), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 500,
        })
    }
})
