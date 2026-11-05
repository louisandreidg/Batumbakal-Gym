# Group 02 School Event Management

Repository: https://github.com/JosephEmmanuelBabas/School_Event_Management_Web_Appli

Snapshot: main ZIP; commit unavailable

Test date: 6 November 2026

Database: grp02_event_management_db

Database setup result: Success with issues

Access-control status: Privileges tested

Database and Flyway migrations worked. Application CRUD, login, role restrictions and database permissions passed. Stale role documentation and the missing documented constraint-test script remain.

## Accounts and responsibilities

| Login | Group role | Responsibility | Privileges |
|---|---|---|---|
| event_owner | Object owner; no privilege group | Setup and Flyway migrations | Owns schema and objects; schema DDL. Not SUPERUSER, CREATEDB or CREATEROLE. |
| event_app | grp02_runtime_grp NOLOGIN | Shared runtime for both application roles | SELECT role; SELECT/INSERT/UPDATE user_account; CRUD six operational tables; SELECT/INSERT audit_log; sequence USAGE. |
| grp02_readonly | grp02_readonly_grp NOLOGIN | Inspection and reporting | SELECT role, venue, event only. No account-table access, writes, sequence or schema CREATE rights. |

## Evidence and script provenance

Existing SQL output, backend tests, authenticated API results and final privilege matrix are retained in evidence/. setup.sql is a reusable reconstruction. access-control.sql is the executed post-Flyway group-grant script. No application source was changed. The source was a ZIP and has no verified commit ID.

The account-only pg_hba rule allows these new project accounts to connect only to their intended database. Prior projects and their grants were preserved. Real connection denials were verified. PUBLIC CONNECT can still appear in privilege-inspection functions for unrelated databases; the connection policy blocks the login before that access path can be used. Keep the policy in place when reproducing this isolation result.

Future objects: Group 2 and ReserveIT require reviewed explicit grants. Group 7 has default SELECT for the reporting group under grp07_owner, but runtime privileges still require review. No blanket future write grants were introduced.

Feedback status: Drafted, not sent. No feedback date is claimed.
