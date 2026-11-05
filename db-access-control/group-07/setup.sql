\set ON_ERROR_STOP on
-- RECONSTRUCTED on 2026-11-06 from verified setup and grants.
-- Fresh database only. No original execution transcript is claimed.
-- Run as postgres; passwords are entered locally, never written here.
CREATE ROLE grp07_runtime_grp NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
CREATE ROLE grp07_readonly_grp NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
CREATE ROLE grp07_owner LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
CREATE ROLE grp07_app LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
CREATE ROLE grp07_readonly LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
\password grp07_owner
\password grp07_app
\password grp07_readonly
GRANT grp07_runtime_grp TO grp07_app;
GRANT grp07_readonly_grp TO grp07_readonly;
CREATE DATABASE grp07_applicantdb OWNER grp07_owner;
REVOKE ALL ON DATABASE grp07_applicantdb FROM PUBLIC;
GRANT CONNECT ON DATABASE grp07_applicantdb TO grp07_runtime_grp,grp07_readonly_grp;
\connect grp07_applicantdb
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
-- Connect as grp07_owner and apply original db/01_schema.sql, then db/02_seed.sql.
-- Apply grants.sql afterwards. Prepend reviewed pg_hba.snippet on your test server.

