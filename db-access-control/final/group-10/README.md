# G10 - UniSync

Repository: https://github.com/CoffyJosh/unisync

Snapshot: main / c3b916a080f3201567f467a456d55c74b9ca3ba8

Database/schema: grp10_unisyncdb / public

Result: Success with issues

Activity 4 status: Privileges tested

Core workflows and SQL permissions worked. Dashboard cancellation fails; Manager editing differs from README.

## Setup and objects

Original init/seed ran only in a newly created empty database. Documented NOLOGIN groups and local logins applied; no prior database was reset.

Eight tables: account, organization, membership, event, venue, event_schedule, registration, notification.

## Accounts and access-control plan

All named groups in the table are NOLOGIN except the explicitly described owner/direct-login cases. SIU means SELECT/INSERT/UPDATE; CRUD includes DELETE. Web roles are enforced by application code, separately from these database roles.

| Login or group | Membership/responsibility | Privileges |
|---|---|---|
| unisync_app | unisync_runtime_grp | SELECT/INSERT/UPDATE and sequences; no physical DELETE. |
| unisync_auditor | unisync_readonly_grp | Approved SELECT columns; account.password_hash excluded. |
| unisync_dba | unisync_admin_grp | Data CRUD and documented schema CREATE; no role/database creation. |

## Representative verification

| Account | Operation | Expected/actual evidence |
|---|---|---|
| unisync_app | SIU and physical DELETE registration | SIU allowed; physical DELETE denied. |
| Member dashboard | Cancel existing registration | HTTP 500; violates expected successful cancellation. |
| Promoted Manager | Edit organization university_name | HTTP 200; differs from README Admin-only rule. |

## Limits and issues

Dashboard handler physically DELETEs while event-page unregister soft-deletes. Bare unbuffered PHP also exposed leading-output/header warnings; normal buffering restored JSON responses. Failures remain recorded.

## SQL and evidence

The SQL files labeled reconstructed describe the inspected configuration. Use the source setup instructions and ../REPRODUCE.md. Actual operation results are linked in ../verification-results.csv.

## Feedback

Yes - 2026-11-06; https://github.com/CoffyJosh/unisync/issues/1
