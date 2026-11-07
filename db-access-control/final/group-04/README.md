# G04 - HealthBridge Clinic

Repository: https://github.com/RainneQuintab/GRP03_PROJECTDB

Snapshot: main / 2e5abb5440c1e2f7cadc364352a598ca220c7bc7

Database/schema: grp03_projectdb / public

Result: Success

Activity 4 status: Privileges tested

Patient/staff/doctor/admin login and appointment flows worked. Restricted SQL and reporting access worked.

## Setup and objects

Original schema, seed, roles, update_reason, update_note_unique, update_billing, create_views and demo_accounts applied. Private local config only.

Eleven tables; appointment_details and visit_records views.

## Accounts and access-control plan

All named groups in the table are NOLOGIN except the explicitly described owner/direct-login cases. SIU means SELECT/INSERT/UPDATE; CRUD includes DELETE. Web roles are enforced by application code, separately from these database roles.

| Login or group | Membership/responsibility | Privileges |
|---|---|---|
| hb_app | hb_staff | Clinical operations; reference reads; documented clinical deletes and backup operations. |
| hb_report | hb_readonly_grp | SELECT approved clinical/reporting tables; staff password hashes withheld. |
| hb_maintenance | hb_admin | Local maintenance role; no role/database creation or schema CREATE. |

## Representative verification

| Account | Operation | Expected/actual evidence |
|---|---|---|
| hb_app | Patient fixture INSERT/UPDATE/DELETE | Allowed; INSERT 0 1, UPDATE 1, DELETE 1; rolled back. |
| hb_report | Read appointments; write patient/read staff hash | SELECT allowed; writes/sensitive read denied. |
| hb_maintenance | Specialty CRUD; CREATE ROLE/DATABASE | CRUD allowed; administrative escalation denied. |

## Limits and issues

Roster Group 04 despite repository/database names containing 03. Test-created application records remain only in the new local test database.

## SQL and evidence

The SQL files labeled reconstructed describe the inspected configuration. Use the source setup instructions and ../REPRODUCE.md. Actual operation results are linked in ../verification-results.csv.

## Feedback

No - no new owner correction identified

[Shared permission and application tests](../shared-tests/README.md)
