# Group 07 Applicant Management System

Repository: https://github.com/mang2mas/grp07-applicant-management-system

Snapshot: main / 2ccec581b94708d5a8f864c353281454dc725fcd

Test date: 6 November 2026

Database: grp07_applicantdb

Database setup result: Success

Access-control status: Privileges tested

Database setup and application startup worked. Basic CRUD, validation, CSRF and restricted database operations passed.

## Accounts and responsibilities

| Login | Group role | Responsibility | Privileges |
|---|---|---|---|
| grp07_owner | Database/object owner | Provision schema and sample data | Owns database and tables. No SUPERUSER, CREATEDB or CREATEROLE. |
| grp07_app | grp07_runtime_grp NOLOGIN | Application runtime | CRUD on operational tables, SELECT only application_status; sequence USAGE. |
| grp07_readonly | grp07_readonly_grp NOLOGIN | Reporting/inspection | SELECT on the eight application tables; no writes or DDL. This is a database role, not a web login. |

## Evidence and script provenance

group07-sql-results.json contains actual SQL, account, expected result, actual result and PostgreSQL output. group07-http-results.json records page/CRUD/CSRF results. setup.sql and grants.sql are reconstructed from the verified final configuration, not original execution transcripts. Run original db/01_schema.sql and db/02_seed.sql as grp07_owner before grants.sql. Test harnesses were parameterized for a locally held encrypted credential file.

The account-only pg_hba rule allows these new project accounts to connect only to their intended database. Prior projects and their grants were preserved. Real connection denials were verified. PUBLIC CONNECT can still appear in privilege-inspection functions for unrelated databases; the connection policy blocks the login before that access path can be used. Keep the policy in place when reproducing this isolation result.

Future objects: Group 2 and ReserveIT require reviewed explicit grants. Group 7 has default SELECT for the reporting group under grp07_owner, but runtime privileges still require review. No blanket future write grants were introduced.

Feedback status: Drafted, not sent. No feedback date is claimed.
