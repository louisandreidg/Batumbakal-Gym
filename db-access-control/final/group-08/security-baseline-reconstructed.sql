-- Reconstructed verified PUBLIC restrictions; not an execution transcript.
-- Fresh dedicated test database only; apply alongside approved role grants,
-- ownership setup and the matching connection-policy snippet.
-- Review before use. Existing project grants must not be blindly changed.
REVOKE ALL ON DATABASE "catering_management_db" FROM PUBLIC;
REVOKE CREATE ON SCHEMA "public" FROM PUBLIC;
-- Remove the broad original reporting grant before restoring approved columns.
REVOKE SELECT ON public.customer,public.admin FROM catering_readonly_grp;
