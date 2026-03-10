-- Enable Realtime for key tables
BEGIN;
  -- Remove tables from publication if they already exist to avoid errors (optional but safer)
  -- Actually, we can just add them.
  
  -- Create the publication if it doesn't exist (Supabase usually has 'supabase_realtime')
  -- But we can just add tables to it.
  ALTER PUBLICATION supabase_realtime ADD TABLE public.profiles;
  ALTER PUBLICATION supabase_realtime ADD TABLE public.user_roles;
  ALTER PUBLICATION supabase_realtime ADD TABLE public.inventory;
  ALTER PUBLICATION supabase_realtime ADD TABLE public.waybills;
  ALTER PUBLICATION supabase_realtime ADD TABLE public.warehouses;
  ALTER PUBLICATION supabase_realtime ADD TABLE public.items;
  ALTER PUBLICATION supabase_realtime ADD TABLE public.allocated_resources;
COMMIT;
