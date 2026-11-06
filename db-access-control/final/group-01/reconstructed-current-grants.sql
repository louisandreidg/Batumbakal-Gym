-- RECONSTRUCTED FROM ADMINISTRATIVE CONFIGURATION AUDIT; NOT AN EXECUTION LOG.
-- Reproduces observed grants, NOT a complete least-privilege recommendation.
-- Fresh database/role only. Never use this to reset existing credentials.
\set ON_ERROR_STOP on
CREATE ROLE dropboxed_app LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
\password dropboxed_app
GRANT CONNECT ON DATABASE "dropboxed_db" TO dropboxed_app;
\connect "dropboxed_db"
GRANT USAGE ON SCHEMA dropboxed TO dropboxed_app;
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA dropboxed TO dropboxed_app;
-- Sequence ACLs must be audited before adding sequence grants; no unverified grant is asserted.
-- NOLOGIN memberships and PUBLIC isolation are NOT implemented by this reconstruction.
