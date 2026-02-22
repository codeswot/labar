-- Migration for Inventory and Waybills

-- 1. Create the inventory table
create table if not exists public.inventory (
  id uuid primary key default gen_random_uuid(),
  warehouse_id uuid not null references public.warehouses(id) on delete cascade,
  item_name text not null,
  quantity numeric not null default 0,
  unit text not null, -- e.g., 'bags', 'kg', 'liters'
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- Unique index to prevent duplicate items in the same warehouse
create unique index if not exists idx_unique_inventory_item on public.inventory (warehouse_id, item_name);

-- 2. Create the waybills table
create table if not exists public.waybills (
  id uuid primary key default gen_random_uuid(),
  waybill_number text not null unique,
  warehouse_id uuid not null references public.warehouses(id) on delete restrict,
  destination text not null,
  driver_name text not null,
  driver_phone text not null,
  vehicle_number text not null,
  item_name text not null,
  quantity numeric not null,
  unit text not null,
  dispatch_date timestamp with time zone default now(),
  status text default 'dispatched', -- e.g., pending, dispatched, delivered
  created_by uuid not null references auth.users(id),
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- 3. Waybill number generation trigger
create or replace function public.generate_waybill_no()
returns trigger as $$
begin
  -- Generates a sequence like WB-A3F192C
  new.waybill_number := 'WB-' || upper(substr(md5(random()::text), 1, 8));
  return new;
end;
$$ language plpgsql;

create or replace trigger trg_assign_waybill_no
  before insert on public.waybills
  for each row when (new.waybill_number is null)
  execute function public.generate_waybill_no();

-- 4. Enable Row Level Security (RLS)
alter table public.inventory enable row level security;
alter table public.waybills enable row level security;

-- Policies for inventory
create policy "Admins and agents can view inventory" on public.inventory
  for select using (auth.uid() in (select id from public.user_roles where role in ('admin', 'super_admin', 'agent')));

create policy "Admins and agents can modify inventory" on public.inventory
  for all using (auth.uid() in (select id from public.user_roles where role in ('admin', 'super_admin', 'agent')));

-- Policies for waybills
create policy "Admins and agents can view waybills" on public.waybills
  for select using (auth.uid() in (select id from public.user_roles where role in ('admin', 'super_admin', 'agent')));

create policy "Admins and agents can insert waybills" on public.waybills
  for insert with check (auth.uid() in (select id from public.user_roles where role in ('admin', 'super_admin', 'agent')));

create policy "Admins and agents can update waybills" on public.waybills
  for update using (auth.uid() in (select id from public.user_roles where role in ('admin', 'super_admin', 'agent')));
