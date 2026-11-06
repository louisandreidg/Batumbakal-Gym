-- Group roles (no login)
CREATE ROLE unisync_admin_grp    NOLOGIN;
CREATE ROLE unisync_runtime_grp  NOLOGIN;
CREATE ROLE unisync_readonly_grp NOLOGIN;

-- Login accounts
CREATE ROLE unisync_app     LOGIN  IN ROLE unisync_runtime_grp;
CREATE ROLE unisync_dba     LOGIN  IN ROLE unisync_admin_grp;
CREATE ROLE unisync_auditor LOGIN  IN ROLE unisync_readonly_grp;

-- Database and schema access
GRANT CONNECT ON DATABASE grp10_unisyncdb
    TO unisync_admin_grp, unisync_runtime_grp, unisync_readonly_grp;

REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public
    TO unisync_admin_grp, unisync_runtime_grp, unisync_readonly_grp;
GRANT CREATE ON SCHEMA public TO unisync_admin_grp;

-- Admin group
GRANT ALL PRIVILEGES ON ALL TABLES    IN SCHEMA public TO unisync_admin_grp;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO unisync_admin_grp;

-- Runtime group (no DELETE, no DDL)
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO unisync_runtime_grp;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO unisync_runtime_grp;

-- Read-only group (password_hash hidden)
GRANT SELECT ON
    organization, membership, event, venue,
    event_schedule, registration, notification
    TO unisync_readonly_grp;
GRANT SELECT (account_id, account_name, email, avatar_url, account_status)
    ON account TO unisync_readonly_grp;

