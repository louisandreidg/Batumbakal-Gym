# G03 - PAWPAW Veterinary

Repository: https://github.com/rubiakylashane/GRP03_PAWPAW

Snapshot: Earlier local checkout; tested revision not established

Database/schema: group3_Pawpaw / public

Result: Success with issues

Activity 4 status: Planning

Existing objects and broad direct grants confirmed. Earlier application/CRUD claims lack recovered raw operation logs.

## Setup and objects

Existing database retained. Administrative configuration audit only; original credentials were not reset.

Fourteen tables for accounts, pets, appointments, clinical records, sessions, notifications and audit.

## Accounts and access-control plan

All named groups in the table are NOLOGIN except the explicitly described owner/direct-login cases. SIU means SELECT/INSERT/UPDATE; CRUD includes DELETE. Web roles are enforced by application code, separately from these database roles.

| Login or group | Membership/responsibility | Privileges |
|---|---|---|
| pawpaw_app | No evidenced NOLOGIN group | Direct table CRUD; non-superuser, no role/database creation. Audit/history protection needs review. |

## Representative verification

| Account | Operation | Expected/actual evidence |
|---|---|---|
| postgres | Inspect objects and grants | Inventory returned; administrative metadata only. |
| pawpaw_app | Password-free login attempt | No password supplied; no restricted-account DML result claimed. |

## Limits and issues

Tracker previously says Success. NOLOGIN roles, reporting scope, account-only isolation and actual restricted-account test output remain outstanding. PUBLIC CONNECT persists; existing grants were preserved as requested.

## SQL and evidence

The SQL files labeled reconstructed describe the inspected configuration. Use the source setup instructions and ../REPRODUCE.md. Actual operation results are linked in ../verification-results.csv.

## Feedback

No - evidence/implementation gaps remain in our local testing

## Remaining work

Recover or securely configure the original application login, review least-privilege table requirements, add NOLOGIN/runtime/reporting roles and account isolation, and capture actual allowed/denied operations. Existing grants and application data were left unchanged as requested. These are not marked Completed.
