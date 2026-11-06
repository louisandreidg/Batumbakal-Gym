-- RECONSTRUCTED from the final verified configuration, not an original log.
-- Connected to grp07_applicantdb as grp07_owner after original schema and seed.
GRANT USAGE ON SCHEMA public TO grp07_runtime_grp,grp07_readonly_grp;
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO grp07_runtime_grp;
REVOKE INSERT,UPDATE,DELETE ON public.application_status FROM grp07_runtime_grp;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO grp07_runtime_grp;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grp07_readonly_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE grp07_owner IN SCHEMA public
  GRANT SELECT ON TABLES TO grp07_readonly_grp;
-- Runtime grants for future objects must be reviewed in each migration.

