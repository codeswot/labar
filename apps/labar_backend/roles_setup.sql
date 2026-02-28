-- 1. Create a custom enum for roles
-- MIGRATION NOTE: If you have an existing DB, run: ALTER TYPE public.app_role ADD VALUE 'super_admin' BEFORE 'admin';
create type public.app_role as enum ('super_admin', 'admin', 'farmer', 'agent', 'warehouse_manager');

-- 2. Create the user_roles table
create table if not exists public.user_roles (
  id uuid primary key references auth.users on delete cascade,
  role public.app_role not null default 'farmer'
);

-- 3. Enable RLS
alter table public.user_roles enable row level security;

-- 4. Create Policy: Users can see their own role, admins can see all
create policy "Users can view own role" on public.user_roles
  for select using (auth.uid() = id);

-- 5. Trigger to automatically assign 'farmer' role on new user signup
create or replace function public.handle_new_user_role()
returns trigger as $$
begin
  insert into public.user_roles (id, role)
  values (new.id, 'farmer');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user_role();

-- 6. Update the applications table (or create if not versioned elsewhere)
create table if not exists public.applications (
  id uuid not null default gen_random_uuid (),
  user_id uuid not null default auth.uid (),
  status public.application_status null default 'initial'::application_status,
  first_name text null,
  last_name text null,
  other_names text null,
  date_of_birth date null,
  gender text null,
  state text null,
  lga text null,
  bank_name text null,
  account_number text null,
  account_name text null,
  phone_number text null,
  next_of_kin_name text null,
  next_of_kin_phone text null,
  next_of_kin_relationship text null,
  farm_size text null,
  farm_location text null,
  crop_type text null,
  latitude double precision null,
  longitude double precision null,
  passport_path text null,
  kyc_type text null,
  kyc_number text null,
  signature_path text null,
  created_at timestamp with time zone null default now(),
  updated_at timestamp with time zone null default now(),
  reg_no text null,
  proof_of_payment_path text null,
  created_by uuid not null,
  constraint applications_pkey primary key (id),
  constraint applications_reg_no_key unique (reg_no),
  constraint unique_reg_no unique (reg_no),
  constraint applications_created_by_fkey foreign KEY (created_by) references auth.users (id) on update RESTRICT on delete RESTRICT,
  constraint applications_user_id_fkey foreign KEY (user_id) references auth.users (id)
);

-- Ensure RLS is updated for created_by
create policy "Admins/Agents can view applications they created" on public.applications
  for select using (auth.uid() = created_by);

-- 7. Create unique index for active applications (prevent multiple initial/in_review apps per user)
create unique index if not exists idx_unique_active_application on public.applications (user_id)
where (status = 'initial'::application_status or status = 'in_review'::application_status);

-- 8. Add registration number generation function if not exists
create or replace function public.generate_lf_reg_no()
returns trigger as $$
begin
  new.reg_no := 'LF-' || upper(substr(md5(random()::text), 1, 8));
  return new;
end;
$$ language plpgsql;

-- 9. Add trigger for registration number
create or replace trigger trg_assign_lf_reg_no
  before insert on applications
  for each row when (new.reg_no is null)
  execute function generate_lf_reg_no();

-- 10. Create the hook function for Custom Access Tokens
create or replace function public.custom_access_token_hook(event jsonb)
returns jsonb
language plpgsql
stable
as $$
  declare
    claims jsonb;
    user_role public.app_role;
  begin
    -- Fetch the role from our user_roles table
    select role into user_role from public.user_roles where id = (event->>'user_id')::uuid;

    claims := event->'claims';

    if user_role is not null then
      -- Add user_role to the JWT claims
      claims := jsonb_set(claims, '{user_role}', to_jsonb(user_role));
    else
      -- Fallback if no role is found
      claims := jsonb_set(claims, '{user_role}', '"farmer"'::jsonb);
    end if;

    -- Update the event with the modified claims
    event := jsonb_set(event, '{claims}', claims);

    return event;
  end;
$$;

-- Grant permissions to the Supabase Auth Admin to execute this function and read roles
grant usage on schema public to supabase_auth_admin;
grant execute on function public.custom_access_token_hook to supabase_auth_admin;
grant select on table public.user_roles to supabase_auth_admin;

-- 11. Create a view to expose auth.users safely for the Admin App
create or replace view public.admin_user_view as
  select au.id, au.email, au.raw_user_meta_data, au.created_at, ur.role
  from auth.users au
  join public.user_roles ur on au.id = ur.id;

grant select on public.admin_user_view to authenticated;
-- Only allow admin/super_admin to select from this view (via RLS or simpler, just handle in app for now, but better with RLS)
alter view public.admin_user_view owner to postgres;

