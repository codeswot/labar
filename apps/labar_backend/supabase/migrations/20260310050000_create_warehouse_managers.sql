-- Create warehouse_managers table
CREATE TABLE public.warehouse_managers (
  id uuid NOT NULL DEFAULT gen_random_uuid (),
  user_id uuid NOT NULL,
  warehouse_id uuid NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT warehouse_managers_pkey PRIMARY KEY (id),
  CONSTRAINT warehouse_managers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT warehouse_managers_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT warehouse_managers_user_id_key UNIQUE (user_id) -- One manager per user (or one warehouse per manager)
);

-- Enable RLS
ALTER TABLE public.warehouse_managers ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Super Admins can do everything on warehouse_managers"
  ON public.warehouse_managers
  USING (
    EXISTS (
      SELECT 1 FROM public.user_roles
      WHERE user_id = auth.uid() AND role = 'super_admin'
    )
  );

CREATE POLICY "Users can view their own warehouse assignment"
  ON public.warehouse_managers
  FOR SELECT
  USING (user_id = auth.uid());

-- Add to Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.warehouse_managers;
