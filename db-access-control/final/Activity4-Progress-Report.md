# Activity 4 Progress Report

## Automated Group System Testing and Database Verification

COMP 018 Database Administration
Group 09 - Batumbakal Gym
6 November 2026

Members: Louis Andrei de Guzman; Mark Timothy Casilan. Individual task assignments were not supplied.

Repository: https://github.com/louisandreidg/Batumbakal-Gym
Tracker: https://docs.google.com/spreadsheets/d/1BClCa9rEs9o-D9Rp3tUZVhECipJ234zX/edit?gid=2123136180

## Results and submission scope

| Group / project | Result | Short notes |
| G01 DropBoxed | Some issues | Existing objects and direct grants confirmed. Original restricted-login CRUD evidence was not recovered. |
| G02 Eventer / School Event Management | Some issues | Setup, authenticated workflows and account restrictions worked. Role documentation and referenced constraint-test file need correction. |
| G03 PAWPAW Veterinary | Some issues | Existing objects and broad direct grants confirmed. Earlier application/CRUD claims lack recovered raw operation logs. |
| G04 HealthBridge Clinic | Success | Patient/staff/doctor/admin login and appointment flows worked. Restricted SQL and reporting access worked. |
| G05 SHIORI Cafe | Some issues | PostgreSQL and Manager pages work. Supplied cashier workflow tests fail and reference missing handlers. |
| G06 ByaheRentals / Car Rental | Some issues | Setup needed staff primary-key ordering correction. Application login and vehicle CRUD then worked. |
| G07 Applicant Management | Success | Setup, pages, department CRUD, validation, CSRF and restricted SQL worked. |
| G08 Catering Management | Some issues | Login, package CRUD and bookings worked after owner session setup and narrower reporting grants. |
| G10 UniSync | Some issues | Core workflows and SQL permissions worked. Dashboard cancellation fails; Manager editing differs from README. |
| G11 ReserveIT | Success | Setup and requester/staff/admin flows worked. Column restrictions and prohibited operations were verified. |

All other roster projects are represented. G01/G03 have unresolved evidence and least-privilege implementation gaps; their old tracker Success entries are not treated as proof of full Activity 4 completion. No failed or unverified operation is relabeled as passed. The other project folders contain actual account tests and application evidence. Feedback issues were delivered where confirmed owner corrections were identified.

Latest package: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-access-control/final
Report: https://github.com/louisandreidg/Batumbakal-Gym/blob/main/db-access-control/final/Activity4-Progress-Report.pdf

## G01 - DropBoxed

https://github.com/joshxaaaaaa/GRP1_Dropboxed
Snapshot: Earlier local ZIP; revision not established

Database: dropboxed_db / dropboxed. Eight tables including users, complaints, assignments, attachments and status_logs.

Setup/result: Success with issues. Existing database retained. Administrative catalog audit only; no schema reset or credential change.

| Account / role | Group and privilege plan |
| dropboxed_app | No evidenced NOLOGIN group: Direct table CRUD; non-superuser, no role/database creation. Broad grants need review. |

| Account | Operation | Expected / actual result |
| postgres | Inspect objects and grants | Inventory returned; administrative metadata only. |
| dropboxed_app | Password-free login attempt | No password supplied; does not verify an intended-account operation. |

Issues/limits: Tracker previously says Success. Current evidence supports setup metadata only. Tested local source was Downloads/Dropboxed-main (earlier identified as jedelacruz/Dropboxed); identity against registry repo is unverified. NOLOGIN/read-only/isolation and fresh restricted-account operations remain outstanding.

Evidence: group-01/README.md and final-configuration-audit.txt; full account/SQL/output references in verification-results.csv. Feedback: No - evidence/implementation gaps remain in our local testing

## G02 - Eventer / School Event Management

https://github.com/JosephEmmanuelBabas/School_Event_Management_Web_Appli
Snapshot: main ZIP; commit unavailable; SHA256 B251FC9C32CECF3090C7AC0ED14EF11862BE29E89656947DBF3A6F00B86569B3

Database: grp02_event_management_db / school_event_management_db. Nine application tables, Flyway history and identity sequences.

Setup/result: Success with issues. Original Flyway V1-V3 applied as event_owner; backend validates schema. Frontend build/lint and supplied backend/API suites completed.

| Account / role | Group and privilege plan |
| event_owner | Object owner: Schema/migration ownership; no superuser or role/database creation. |
| event_app | grp02_runtime_grp: Read role; SIU user_account; CRUD operational tables; SELECT/INSERT audit_log; sequence USAGE. |
| grp02_readonly | grp02_readonly_grp: SELECT role/venue/event; no writes or account-table access. |

| Account | Operation | Expected / actual result |
| event_app | Operational fixture INSERT/UPDATE/DELETE | Allowed; actual affected-row output retained. |
| event_app | UPDATE/DELETE audit_log; schema/role creation | Denied as expected. |
| grp02_readonly | Approved SELECT; writes and other-DB connection | Read allowed; writes/connection denied. |

Issues/limits: Source snapshot came from a ZIP. docs/user_roles.md uses the wrong schema/role model; docs/testing.md references missing test_constraints.sql. No manual browser walkthrough.

Evidence: group-02/README.md and final-configuration-audit.txt; full account/SQL/output references in verification-results.csv. Feedback: Yes - 2026-11-06; https://github.com/JosephEmmanuelBabas/School_Event_Management_Web_Appli/issues/32

## G03 - PAWPAW Veterinary

https://github.com/rubiakylashane/GRP03_PAWPAW
Snapshot: Earlier local checkout; tested revision not established

Database: group3_Pawpaw / public. Fourteen tables for accounts, pets, appointments, clinical records, sessions, notifications and audit.

Setup/result: Success with issues. Existing database retained. Administrative configuration audit only; original credentials were not reset.

| Account / role | Group and privilege plan |
| pawpaw_app | No evidenced NOLOGIN group: Direct table CRUD; non-superuser, no role/database creation. Audit/history protection needs review. |

| Account | Operation | Expected / actual result |
| postgres | Inspect objects and grants | Inventory returned; administrative metadata only. |
| pawpaw_app | Password-free login attempt | No password supplied; no restricted-account DML result claimed. |

Issues/limits: Tracker previously says Success. NOLOGIN roles, reporting scope, account-only isolation and actual restricted-account test output remain outstanding. PUBLIC CONNECT persists; existing grants were preserved as requested.

Evidence: group-03/README.md and final-configuration-audit.txt; full account/SQL/output references in verification-results.csv. Feedback: No - evidence/implementation gaps remain in our local testing

## G04 - HealthBridge Clinic

https://github.com/RainneQuintab/GRP03_PROJECTDB
Snapshot: main / 2e5abb5440c1e2f7cadc364352a598ca220c7bc7

Database: grp03_projectdb / public. Eleven tables; appointment_details and visit_records views.

Setup/result: Success. Original schema, seed, roles, update_reason, update_note_unique, update_billing, create_views and demo_accounts applied. Private local config only.

| Account / role | Group and privilege plan |
| hb_app | hb_staff: Clinical operations; reference reads; documented clinical deletes and backup operations. |
| hb_report | hb_readonly_grp: SELECT approved clinical/reporting tables; staff password hashes withheld. |
| hb_maintenance | hb_admin: Local maintenance role; no role/database creation or schema CREATE. |

| Account | Operation | Expected / actual result |
| hb_app | Patient fixture INSERT/UPDATE/DELETE | Allowed; INSERT 0 1, UPDATE 1, DELETE 1; rolled back. |
| hb_report | Read appointments; write patient/read staff hash | SELECT allowed; writes/sensitive read denied. |
| hb_maintenance | Specialty CRUD; CREATE ROLE/DATABASE | CRUD allowed; administrative escalation denied. |

Issues/limits: Roster Group 04 despite repository/database names containing 03. Test-created application records remain only in the new local test database.

Evidence: group-04/README.md and final-configuration-audit.txt; full account/SQL/output references in verification-results.csv. Feedback: No - no new owner correction identified

## G05 - SHIORI Cafe

https://github.com/LeeJnsn27/SHIORIcafe-new
Snapshot: main / 8fab8f7139e3f1d4565e5a600b3f3e5cf1f6cad8

Database: grp10_shioricafedb / shioricafe_schema. Seventeen tables plus application views/functions.

Setup/result: Success with issues. Original migrations 001-005 and seed succeeded; Manager bootstrap used the original utility. Runtime/report groups added locally.

| Account / role | Group and privilege plan |
| shiori_app | shiori_runtime_grp: Table CRUD and sequence USAGE; no schema/role/database creation. |
| shiori_report | shiori_readonly_grp: Approved category/menu/table/payment reporting; no staff password-hash access. |

| Account | Operation | Expected / actual result |
| shiori_app | Category fixture INSERT/UPDATE/DELETE | Allowed; actual affected rows; rolled back. |
| shiori_report | Read menu; write category/read staff hash | Read allowed; writes and sensitive read denied. |
| Manager HTTP session | Login/pages; supplied cashier suite | Login/pages worked; cashier suite reported failures. |

Issues/limits: This newer PDO/PostgreSQL snapshot supersedes the historical MySQL-based failure. Runner exits zero despite failed assertions; missing handlers/CSRF failures remain. Database name retains 10, but roster group is 05.

Evidence: group-05/README.md and final-configuration-audit.txt; full account/SQL/output references in verification-results.csv. Feedback: Yes - 2026-11-06; https://github.com/LeeJnsn27/SHIORIcafe-new/issues/1

## G06 - ByaheRentals / Car Rental

https://github.com/123airabels/Car_Rental_Management_System
Snapshot: main / ea2cd1691a08cb0e455fc18b398a7570cac1b7ad

Database: car_rental_db / public. Seventeen tables including vehicles, rentals, payments, inspections, staff and audit.

Setup/result: Success with issues. Original dump failed at payment_received_by_fkey before staff_pkey. Separate resume script established staff PK first and resumed the fresh import; original seed and supplementary SQL applied.

| Account / role | Group and privilege plan |
| app_runtime | car_runtime_grp: SIU operational tables; DELETE vehicle only; audit UPDATE/DELETE denied. |
| car_report | car_readonly_grp: Approved reporting columns; customer/staff password hashes withheld. |
| car_dba | car_admin_grp: Data maintenance; no schema/role/database creation. |

| Account | Operation | Expected / actual result |
| app_runtime | Vehicle-category INSERT/UPDATE; audit write | Fixture SIU allowed; audit UPDATE/DELETE denied. |
| Authenticated admin | Vehicle create/update/delete | Actual HTTP operations worked. |
| car_report | Read vehicles; write/read password hash | Read allowed; writes/hash read denied. |

Issues/limits: Generic roles were mapped to project-specific groups to avoid cluster-wide role collisions. Raw original failure and corrected resume are both retained. No real payments exercised.

Evidence: group-06/README.md and final-configuration-audit.txt; full account/SQL/output references in verification-results.csv. Feedback: Yes - 2026-11-06; https://github.com/123airabels/Car_Rental_Management_System/issues/1

## G07 - Applicant Management

https://github.com/mang2mas/grp07-applicant-management-system
Snapshot: main / 2ccec581b94708d5a8f864c353281454dc725fcd

Database: grp07_applicantdb / public. Eight tables: department, position, applicant, application_status, application, interview, requirement, applicant_requirement.

Setup/result: Success. Original db/01_schema.sql and db/02_seed.sql applied as grp07_owner. Local PHP/session configuration only.

| Account / role | Group and privilege plan |
| grp07_owner | Object owner: Owns database/objects; no superuser or role/database creation. |
| grp07_app | grp07_runtime_grp: CRUD operational tables; SELECT only application_status; sequence USAGE. |
| grp07_readonly | grp07_readonly_grp: SELECT eight tables; no writes or schema CREATE. |

| Account | Operation | Expected / actual result |
| grp07_app | Temporary department CRUD | Actual allowed operations; rolled back. |
| grp07_app | Write application_status; schema/role creation | Denied as expected. |
| grp07_readonly | Read tables; INSERT/UPDATE/DELETE | Read allowed; writes denied. |

Issues/limits: Reporting is a database account, not a web user. Future reporting SELECT is configured under grp07_owner; runtime future-object grants need review.

Evidence: group-07/README.md and final-configuration-audit.txt; full account/SQL/output references in verification-results.csv. Feedback: No - no new owner correction identified

## G08 - Catering Management

https://github.com/yami-sumi/catering-management-system
Snapshot: main / a415ead922213f9b559339ab26e17f30924fb1a1

Database: catering_management_db / public. Eleven application tables plus owner-provisioned session table.

Setup/result: Success with issues. Original schema/seed/roles used with project-specific group names. Owner precreated session storage; reporting table-wide grants on customer/admin replaced with approved columns.

| Account / role | Group and privilege plan |
| catering_app | catering_runtime_grp: Application CRUD and session DML; sequence USAGE; no schema CREATE. |
| catering_report | catering_readonly_grp: Approved reporting tables/columns; customer/admin hashes excluded. |
| catering_admin_grp | NOLOGIN maintenance group: Source maintenance privileges, no independent maintenance login tested. |

| Account | Operation | Expected / actual result |
| catering_app | Package fixture INSERT/UPDATE/DELETE | Allowed; actual affected rows; rolled back. |
| catering_report | Read packages; writes/read password hashes | Reads allowed; writes/sensitive reads denied. |
| Admin/customer sessions | Authentication, package CRUD, bookings | Worked through actual HTTP requests. |

Issues/limits: Original identity-based INSERT worked before explicit sequence USAGE was added; no sequence-permission failure is claimed. Original broad reporting access was corrected locally. Source unchanged.

Evidence: group-08/README.md and final-configuration-audit.txt; full account/SQL/output references in verification-results.csv. Feedback: Yes - 2026-11-06; https://github.com/yami-sumi/catering-management-system/issues/1

## G10 - UniSync

https://github.com/CoffyJosh/unisync
Snapshot: main / c3b916a080f3201567f467a456d55c74b9ca3ba8

Database: grp10_unisyncdb / public. Eight tables: account, organization, membership, event, venue, event_schedule, registration, notification.

Setup/result: Success with issues. Original init/seed ran only in a newly created empty database. Documented NOLOGIN groups and local logins applied; no prior database was reset.

| Account / role | Group and privilege plan |
| unisync_app | unisync_runtime_grp: SELECT/INSERT/UPDATE and sequences; no physical DELETE. |
| unisync_auditor | unisync_readonly_grp: Approved SELECT columns; account.password_hash excluded. |
| unisync_dba | unisync_admin_grp: Data CRUD and documented schema CREATE; no role/database creation. |

| Account | Operation | Expected / actual result |
| unisync_app | SIU and physical DELETE registration | SIU allowed; physical DELETE denied. |
| Member dashboard | Cancel existing registration | HTTP 500; violates expected successful cancellation. |
| Promoted Manager | Edit organization university_name | HTTP 200; differs from README Admin-only rule. |

Issues/limits: Dashboard handler physically DELETEs while event-page unregister soft-deletes. Bare unbuffered PHP also exposed leading-output/header warnings; normal buffering restored JSON responses. Failures remain recorded.

Evidence: group-10/README.md and final-configuration-audit.txt; full account/SQL/output references in verification-results.csv. Feedback: Yes - 2026-11-06; https://github.com/CoffyJosh/unisync/issues/1

## G11 - ReserveIT

https://github.com/sev-villanueva/ReserveIT-Classroom-and-Material-Reservation-System-
Snapshot: main / dd466cabb7c9628fac386a1e55840fd5f0303334

Database: ReserveIT / public. Eight tables: department, app_user, staff, room, material, reservation, reservation_material, penalty; sequences and btree_gist.

Setup/result: Success. Original manage.py role setup, schema initialization, grants, seed and checks completed. Login page served over HTTP.

| Account / role | Group and privilege plan |
| reserveit_owner | Object owner: Owns database/objects; no superuser or role/database creation. |
| reserveit_app | app_runtime_grp: Required SIU; restricted UPDATE columns; DELETE room/material only. |
| reserveit_reporter | app_readonly_grp: Approved reporting and people columns; emails/password hashes withheld. |
| reserveit_dba | app_admin_grp: Data/sequence maintenance; no schema/role/database creation. |

| Account | Operation | Expected / actual result |
| reserveit_app | Temporary material INSERT/UPDATE/DELETE | Actual affected rows observed; rolled back. |
| reserveit_reporter | Approved reads; sensitive people columns/writes | Reads allowed; prohibited operations denied. |
| reserveit_dba | Actual-row UPDATE; schema CREATE | Data UPDATE allowed; schema CREATE denied. |

Issues/limits: Some supplied access cases use WHERE false and prove statement privileges only. Separate observed actual-row SQL and application state assertions provide data-changing evidence. Full original DB exception text was not retained in every source access case.

Evidence: group-11/README.md and final-configuration-audit.txt; full account/SQL/output references in verification-results.csv. Feedback: No - no new owner correction identified

## Evidence, SQL provenance and database security

The full verification-results.csv identifies account, SQL, expected result, actual result, evidence and scope. G02 sql-N.txt preserves statement/output; G07 JSON items preserve SQL/output; ReserveIT CASE numbers match access_test.original.py and access logs. New-project JSON evidence preserves each statement and PostgreSQL output. Separate application JSON/log files retain HTTP outcomes and failures.

A catalog audit confirms objects, attributes and grants only. WHERE false statements confirm SQL privilege enforcement without changing rows. Actual fixture INSERT/UPDATE/DELETE output and application state assertions support data-changing claims. Most supplementary fixture SQL used BEGIN/ROLLBACK; new application test records may remain in the dedicated test databases. Existing project data was not reset.

PostgreSQL roles are separate from web users. NOLOGIN groups hold privileges and LOGIN accounts inherit them. Shared runtime accounts rely on application authorization for end-user differences. Setup owners are distinct from runtime/reporting logins. New restricted accounts have no SUPERUSER, CREATEDB or CREATEROLE. UniSync DBA intentionally has schema CREATE; ordinary runtime/reporters and the other tested maintenance accounts do not.

New-project PUBLIC database/schema access was restricted. Existing unrelated PUBLIC CONNECT grants were preserved. Account-specific local pg_hba rules allow each new account its intended database and reject other connections. Actual cross-database login denials were recorded. Reproduction requires the matching snippet in the correct policy order; do not replace the server policy wholesale. Existing G01/G03 have not been brought to that state.

Sensitive reporting columns were excluded for ReserveIT, SHIORI, Car Rental, Catering and UniSync. G07 reporting retains documented whole-table SELECT. Runtime audit/history protections vary by source requirements; broad SHIORI CRUD and original G01/G03 grants should not be described as universally strict least privilege. Sequence access was exercised through generated identifiers. Default privileges were not universally enabled: Group 7 reporting defaults apply under grp07_owner; future objects elsewhere require explicit review.

### SQL scripts and provenance

| Files | Meaning and use |
| Original setup/grants copies where retained | G02 access-control.sql is an executed grant adjustment; G11 source setup/grants use manage.py substitution. G07 setup/grants are labeled reconstructions. All need original schema prerequisites. |
| reconstructed-catalog-grants.sql in every group | Current catalog-derived CREATE ROLE, membership and ACL statements, with no password. Not an execution record or complete security installer; omits ownership/default/function ACLs. Do not overwrite existing roles. |
| security-baseline-reconstructed.sql (new groups) | Reconstructed PUBLIC revocations matching verified setup. Review with group grants and original object ownership; do not execute against existing projects blindly. |
| Car Rental resume SQL / role documentation / snippets | Retain actual ordering fix, UniSync documented role setup and project-specific connection policy. Test harnesses require locally held credentials excluded from the submission. |

## Confirmed issues and attempted fixes

| Project | Issue / action / remaining result |
| G01 / G03 | Original account output unavailable; broad direct grants and missing NOLOGIN/read-only/isolation evidence. Current audit supplied; existing projects preserved. Work remains. |
| G02 | Corrected local role/connection setup. Source role/schema docs and missing documented SQL test remain for owners. |
| G05 | Latest PostgreSQL migration works; old MySQL failure superseded. Cashier runner routes/failures and zero failure exit status remain. |
| G06 | Foreign-key import order fixed locally with separate resume SQL; owner schema reorder remains. |
| G08 | Owner-provisioned sessions and narrowed reporting columns fixed local setup; source guidance/grants need equivalent changes. |
| G10 | Dashboard physical DELETE conflicts with runtime policy; Manager organization edit conflicts with README. Unbuffered login warnings mitigated by normal buffering. Source fixes remain. |

## Owner feedback and remaining actions

JosephEmmanuelBabas/School_Event_Management_Web_Appli
Activity 4 feedback: schema/role documentation and missing constraint test
Sent: 2026-11-06T15:40:57Z
https://github.com/JosephEmmanuelBabas/School_Event_Management_Web_Appli/issues/32

LeeJnsn27/SHIORIcafe-new
Activity 4 feedback: cashier workflow tests use missing handler paths
Sent: 2026-11-06T15:40:58Z
https://github.com/LeeJnsn27/SHIORIcafe-new/issues/1

123airabels/Car_Rental_Management_System
Activity 4 feedback: schema creates payment foreign key before staff primary key
Sent: 2026-11-06T15:40:59Z
https://github.com/123airabels/Car_Rental_Management_System/issues/1

yami-sumi/catering-management-system
Activity 4 feedback: provision session storage and narrow reporting grants
Sent: 2026-11-06T15:41:01Z
https://github.com/yami-sumi/catering-management-system/issues/1

CoffyJosh/unisync
Activity 4 feedback: dashboard cancellation and documented role mismatches
Sent: 2026-11-06T15:41:02Z
https://github.com/CoffyJosh/unisync/issues/1

The issue links above are actual delivered feedback, not drafts. G04/G07/G11 had no new owner correction identified; no success-only issue was sent. G01/G03 gaps are described as gaps in our local work rather than verified owner defects.

The provided Activity4-Log-paste-ready.tsv contains the required columns and all roster projects except our own G09. No live tracker cell was edited. Paste the table into a new Activity 4 Log tab at A1, review the G01/G03 limitations and submit the report/repository links using the instructor process. Existing tracker Success rows were preserved in the read-only snapshot and were not overwritten.

## AI usage declaration

We used AI to help understand the activity, plan PostgreSQL roles, prepare SQL commands, troubleshoot setup errors, organize evidence and draft this report. The assistant also ran the documented commands and tests in our local environment and sent the feedback issues linked above. The report separates actual output from reconstructed scripts and unverified claims. We are responsible for reviewing the files, understanding the permissions and submitting accurate results.

## Remaining limitations

G01/G03 need securely configured account access, proper privilege groups/reporting/isolation and actual restricted-account operation evidence before Activity 4 can be called fully complete. Their original application tests were not repeated. Source identity for the old DropBoxed local copy remains unresolved. Known SHIORI/UniSync functional failures are retained. External email/SMS, real payments, deployment security, load and manual browser usability were not tested. This report records current evidence rather than certifying production readiness.
