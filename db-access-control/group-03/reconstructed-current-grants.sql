-- RECONSTRUCTED FROM ADMINISTRATIVE CONFIGURATION AUDIT; NOT AN EXECUTION LOG.
-- Reproduces observed grants, NOT a complete least-privilege recommendation.
-- Fresh database/role only. Never use this to reset existing credentials.
\set ON_ERROR_STOP on
CREATE ROLE pawpaw_app LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
\password pawpaw_app
GRANT CONNECT ON DATABASE "group3_Pawpaw" TO pawpaw_app;
\connect "group3_Pawpaw"
GRANT USAGE ON SCHEMA public TO pawpaw_app;
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO pawpaw_app;
-- Sequence ACLs must be audited before adding sequence grants; no unverified grant is asserted.
-- NOLOGIN memberships and PUBLIC isolation are NOT implemented by this reconstruction.
