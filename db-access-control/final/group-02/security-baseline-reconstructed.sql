-- Reconstructed verified PUBLIC restrictions; not an execution transcript.
-- Fresh dedicated test database only; apply alongside approved role grants,
-- ownership setup and the matching connection-policy snippet.
-- Review before use. Existing project grants must not be blindly changed.
REVOKE ALL ON DATABASE "grp02_event_management_db" FROM PUBLIC;
REVOKE CREATE ON SCHEMA "school_event_management_db" FROM PUBLIC;
