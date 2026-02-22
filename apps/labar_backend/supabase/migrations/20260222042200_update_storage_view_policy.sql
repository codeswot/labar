-- Migration to allow admin, super_admin, and agent to view files in the 'uploads' bucket.

-- Drop the existing policy.
-- Name matched from schema.sql
DROP POLICY IF EXISTS "Users can view their own files" ON storage.objects;

-- Create the new policy allowing internal roles to view all uploads.
CREATE POLICY "Allow users to view own files and internal staff to view all"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'uploads' AND (
    (auth.uid())::text = (storage.foldername(name))[1]
    OR 
    (EXISTS (
      SELECT 1 FROM public.user_roles
      WHERE id = auth.uid()
      AND role::text IN ('admin', 'super_admin', 'agent')
      AND active = true
    ))
  )
);
