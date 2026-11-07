# G02 - Eventer / School Event Management

Repository: https://github.com/JosephEmmanuelBabas/School_Event_Management_Web_Appli

Snapshot: main ZIP; commit unavailable; SHA256 B251FC9C32CECF3090C7AC0ED14EF11862BE29E89656947DBF3A6F00B86569B3

Database/schema: grp02_event_management_db / school_event_management_db

Result: Success with issues

Activity 4 status: Privileges tested

Setup, authenticated workflows and account restrictions worked. Role documentation and referenced constraint-test file need correction.

## Setup and objects

Original Flyway V1-V3 applied as event_owner; backend validates schema. Frontend build/lint and supplied backend/API suites completed.

Nine application tables, Flyway history and identity sequences.

## Accounts and access-control plan

All named groups in the table are NOLOGIN except the explicitly described owner/direct-login cases. SIU means SELECT/INSERT/UPDATE; CRUD includes DELETE. Web roles are enforced by application code, separately from these database roles.

| Login or group | Membership/responsibility | Privileges |
|---|---|---|
| event_owner | Object owner | Schema/migration ownership; no superuser or role/database creation. |
| event_app | grp02_runtime_grp | Read role; SIU user_account; CRUD operational tables; SELECT/INSERT audit_log; sequence USAGE. |
| grp02_readonly | grp02_readonly_grp | SELECT role/venue/event; no writes or account-table access. |

## Representative verification

| Account | Operation | Expected/actual evidence |
|---|---|---|
| event_app | Operational fixture INSERT/UPDATE/DELETE | Allowed; actual affected-row output retained. |
| event_app | UPDATE/DELETE audit_log; schema/role creation | Denied as expected. |
| grp02_readonly | Approved SELECT; writes and other-DB connection | Read allowed; writes/connection denied. |

## Limits and issues

Source snapshot came from a ZIP. docs/user_roles.md uses the wrong schema/role model; docs/testing.md references missing test_constraints.sql. No manual browser walkthrough.

## SQL and evidence

The SQL files labeled reconstructed describe the inspected configuration. Use the source setup instructions and ../REPRODUCE.md. Actual operation results are linked in ../verification-results.csv.

## Feedback

Yes - 2026-11-06; https://github.com/JosephEmmanuelBabas/School_Event_Management_Web_Appli/issues/32
