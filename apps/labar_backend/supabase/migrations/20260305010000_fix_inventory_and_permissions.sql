-- Migration to fix inventory deductions, warehouse manager permissions, and user deletion

-- 1. Fix User Deletion Constraints
-- Make created_by nullable in applications and waybills to allow deleting creators
ALTER TABLE public.applications ALTER COLUMN created_by DROP NOT NULL;
ALTER TABLE public.applications DROP CONSTRAINT IF EXISTS applications_created_by_fkey;
ALTER TABLE public.applications ADD CONSTRAINT applications_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL;

-- 2. Ensure allocated_resources table exists (as used in admin repository)
CREATE TABLE IF NOT EXISTS public.allocated_resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  application UUID NOT NULL REFERENCES public.applications(id) ON DELETE CASCADE,
  item UUID NOT NULL REFERENCES public.inventory(id) ON DELETE CASCADE,
  quantity NUMERIC NOT NULL,
  collection_address TEXT,
  is_collected BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Update Warehouse table
-- (Removed manager_id check as it is not used)

-- 4. Inventory Deduction Triggers

-- Trigger for Waybills
CREATE OR REPLACE FUNCTION public.deduct_inventory_on_waybill()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.inventory
  SET quantity = quantity - NEW.quantity,
      updated_at = NOW()
  WHERE warehouse_id = NEW.warehouse_id
    AND item_name = NEW.item_name;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Inventory item % not found in warehouse %', NEW.item_name, NEW.warehouse_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_deduct_inventory_on_waybill ON public.waybills;
CREATE TRIGGER trg_deduct_inventory_on_waybill
AFTER INSERT ON public.waybills
FOR EACH ROW EXECUTE FUNCTION public.deduct_inventory_on_waybill();

-- Trigger for Allocated Resources
CREATE OR REPLACE FUNCTION public.handle_inventory_on_allocation()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE public.inventory
    SET quantity = quantity - NEW.quantity,
        updated_at = NOW()
    WHERE id = NEW.item;
    
    RETURN NEW;
  ELSIF (TG_OP = 'DELETE') THEN
    UPDATE public.inventory
    SET quantity = quantity + OLD.quantity,
        updated_at = NOW()
    WHERE id = OLD.item;
    
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_handle_inventory_on_allocation ON public.allocated_resources;
CREATE TRIGGER trg_handle_inventory_on_allocation
AFTER INSERT OR DELETE ON public.allocated_resources
FOR EACH ROW EXECUTE FUNCTION public.handle_inventory_on_allocation();

-- 5. Warehouse Manager Permissions (RLS)

-- Enable RLS on allocated_resources if not already
ALTER TABLE public.allocated_resources ENABLE ROW LEVEL SECURITY;

-- Waybills Policies

-- Allocated Resources Policies
DROP POLICY IF EXISTS "Admins and agents can view allocations" ON public.allocated_resources;
CREATE POLICY "Admins and agents can view allocations" ON public.allocated_resources
  FOR SELECT USING (auth.uid() IN (SELECT id FROM public.user_roles WHERE role IN ('admin', 'super_admin', 'agent')));

-- Allocations Policies handled above
