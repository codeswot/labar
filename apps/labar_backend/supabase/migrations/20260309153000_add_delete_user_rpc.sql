-- RPC to safely delete a user and all their related data
-- This is more robust than calling auth.admin.deleteUser from edge functions 
-- when there are complex foreign key relationships.

CREATE OR REPLACE FUNCTION public.delete_user_admin(user_id_to_delete UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER -- Runs with the privileges of the creator (postgres)
SET search_path = public, auth
AS $$
BEGIN
  -- 1. Pre-emptively clean up public schema references
  -- Most of these have ON DELETE CASCADE or SET NULL, but being explicit ensures no blockers.
  
  -- Remove roles and profiles
  DELETE FROM public.user_roles WHERE id = user_id_to_delete;
  DELETE FROM public.profiles WHERE id = user_id_to_delete;
  
  -- Handle references where the user might be a creator or manager
  UPDATE public.waybills SET created_by = NULL WHERE created_by = user_id_to_delete;
  UPDATE public.applications SET created_by = NULL WHERE created_by = user_id_to_delete;

  -- 2. Delete the user from auth.users
  -- This will trigger the internal cleanup of auth.identities, auth.sessions, etc.
  DELETE FROM auth.users WHERE id = user_id_to_delete;
  
  -- Note: If there are other tables referencing applications or profiles with CASCADE,
  -- those will be cleaned up automatically by Postgres.
END;
$$;
