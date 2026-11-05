# Group 11 ReserveIT

Repository: https://github.com/sev-villanueva/ReserveIT-Classroom-and-Material-Reservation-System-

Snapshot: main / dd466cabb7c9628fac386a1e55840fd5f0303334

Test date: 6 November 2026

Database: ReserveIT

Database setup result: Success

Access-control status: Privileges tested

Database setup and application startup worked. Requester, staff and administrator workflows worked; column restrictions, read-only access and prohibited database operations were verified.

## Accounts and responsibilities

| Login | Group role | Responsibility | Privileges |
|---|---|---|---|
| reserveit_owner | Database/object owner | Setup only | Owns database/objects; schema DDL. No SUPERUSER, CREATEDB or CREATEROLE. |
| reserveit_app | app_runtime_grp NOLOGIN | Shared requester/staff/admin runtime | SELECT and required INSERT; only documented UPDATE columns; DELETE only room/material; required sequence USAGE. |
| reserveit_reporter | app_readonly_grp NOLOGIN | Read-only reporting | Approved tables and approved people columns; cannot read emails/password hashes or modify data. |
| reserveit_dba | app_admin_grp NOLOGIN | Data maintenance | Table CRUD and sequence maintenance; no schema DDL, role/database creation or superuser rights. |

## Evidence and script provenance

roles_setup.sql and grants.sql are unmodified copies from the tested source repository, with original password placeholders. roles_setup.sql is executed by original manage.py setup-roles, which substitutes DB name and local passwords; do not run its placeholders directly in psql. Original setup, schema and seed completed successfully; configuration-audit.txt confirms existing objects. smoke/access logs are actual executions. access_test.original.py documents each SQL statement. WHERE false cases test SQL privilege enforcement without changing rows; successful data-changing workflows are separately covered by the smoke suite and observed runtime CRUD. The supplied smoke suite retains test rows in this development database.

The account-only pg_hba rule allows these new project accounts to connect only to their intended database. Prior projects and their grants were preserved. Real connection denials were verified. PUBLIC CONNECT can still appear in privilege-inspection functions for unrelated databases; the connection policy blocks the login before that access path can be used. Keep the policy in place when reproducing this isolation result.

Future objects: Group 2 and ReserveIT require reviewed explicit grants. Group 7 has default SELECT for the reporting group under grp07_owner, but runtime privileges still require review. No blanket future write grants were introduced.

Feedback status: Drafted, not sent. No feedback date is claimed.
