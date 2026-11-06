\set ON_ERROR_STOP on
-- Reference for a fresh installation only. No DROP/reset operations.
-- Run as local provisioning administrator. Never paste real passwords here.
CREATE ROLE grp02_runtime_grp NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
CREATE ROLE grp02_readonly_grp NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
CREATE ROLE event_owner LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
CREATE ROLE event_app LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
CREATE ROLE grp02_readonly LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE;
\password event_owner
\password event_app
\password grp02_readonly
GRANT grp02_runtime_grp TO event_app;
GRANT grp02_readonly_grp TO grp02_readonly;
CREATE DATABASE grp02_event_management_db;
REVOKE ALL ON DATABASE grp02_event_management_db FROM PUBLIC;
GRANT CONNECT ON DATABASE grp02_event_management_db TO event_owner,grp02_runtime_grp,grp02_readonly_grp;
\connect grp02_event_management_db
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
CREATE SCHEMA school_event_management_db AUTHORIZATION event_owner;
CREATE EXTENSION btree_gist SCHEMA public;
GRANT USAGE ON SCHEMA public TO event_owner;
GRANT USAGE ON SCHEMA school_event_management_db TO grp02_runtime_grp,grp02_readonly_grp;
-- Now run the original backend with Flyway V1-V3 as event_owner, runtime event_app.
-- Then apply access-control.sql, and prepend the reviewed Group 2 connection policy.
-- Local execution used equivalent noninteractive SQL and generated DPAPI-held passwords.

