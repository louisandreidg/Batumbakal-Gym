# Activity 5 Database Maintenance and Monitoring

COMP 018 Database Administration
Group 09 Batumbakal Gym
7 November 2026

Members: Louis Andrei de Guzman; Mark Timothy Casilan.

Repository: https://github.com/louisandreidg/Batumbakal-Gym
Tracker: https://docs.google.com/spreadsheets/d/1BClCa9rEs9o-D9Rp3tUZVhECipJ234zX/edit?gid=2123136180
Evidence: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-maintenance

## Results and scope

This report continues Activity 4 using its existing PostgreSQL accounts and separate local test databases. It records health snapshots, available logs, authorized maintenance and safe application SELECT plans. Authentication and privilege limitations are retained rather than bypassed.

| Project | Health result | Maintenance and priority |
| G01 DropBoxed | Not reachable | Not run - intended-account authentication unavailable; Immediate action |
| G02 Eventer / School Event Management | Healthy | ANALYZE and ordinary VACUUM on school_event_management_db.event; 2026-11-07; Follow-up action |
| G03 PAWPAW Veterinary | Not reachable | Not run - intended-account authentication unavailable; Immediate action |
| G04 HealthBridge Clinic | Healthy | ANALYZE and ordinary VACUUM on public.appointments; 2026-11-07; Follow-up action |
| G05 SHIORI Cafe | Issues found | Withheld - existing account lacks MAINTAIN/ownership; proposed commands supplied; Follow-up action |
| G06 ByaheRentals / Car Rental | Healthy | ANALYZE and ordinary VACUUM on public.vehicle; 2026-11-07; Follow-up action |
| G07 Applicant Management | Healthy | ANALYZE and ordinary VACUUM on public.department; 2026-11-07; Follow-up action |
| G08 Catering Management | Issues found | Withheld - existing account lacks MAINTAIN/ownership; proposed commands supplied; Follow-up action |
| G10 UniSync | Healthy | ANALYZE and ordinary VACUUM on public.registration; 2026-11-07; Follow-up action |
| G11 ReserveIT | Healthy | ANALYZE and ordinary VACUUM on public.reservation; 2026-11-07; Follow-up action |

Healthy means no issue was detected in the visible snapshot and selected maintenance completed. It is not a statement about every application workflow or long-term health. G01/G03 are unavailable to their intended accounts, not proven server outages. G05/G08 need maintenance authorization. No new public feedback was posted and the live tracker was not edited.

Scripts and outcomes are preserved in each group folder. EXPLAIN preceded EXPLAIN ANALYZE; only safe SELECT statements were executed. No superuser was substituted, no live application row was deleted and no database was reset.

## G01 DropBoxed

Repository: https://github.com/joshxaaaaaa/GRP1_Dropboxed
Snapshot: Earlier local ZIP; revision not established

Database/schema: dropboxed_db / dropboxed
Result: Not reachable | Priority: Immediate action

### Accounts and health

Inspection: dropboxed_app; application query: dropboxed_app; maintenance candidate: dropboxed_app. Not verified this activity; prior metadata audit only.

The client returned fe_sendauth: no password supplied. This is an authentication-configuration blocker, not evidence that PostgreSQL is down.

### Logs and maintenance

Current connection.txt reports a missing client password. Shared historical errors are not reliably attributable to this project unless the line identifies the account or database. The database was not inspected through an administrator workaround.

Not run - intended-account authentication unavailable

### Recommendation and limits

Securely configure the original Activity 4 application-account password and finish the unresolved access-control plan; then rerun monitoring. Do not reset another project or use postgres to bypass the account.

Evidence folder: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-maintenance/group-01
Feedback: No - drafted for owner review; not sent

## G02 Eventer / School Event Management

Repository: https://github.com/JosephEmmanuelBabas/School_Event_Management_Web_Appli
Snapshot: main ZIP; commit unavailable; SHA256 B251FC9C32CECF3090C7AC0ED14EF11862BE29E89656947DBF3A6F00B86569B3

Database/schema: grp02_event_management_db / school_event_management_db
Result: Healthy | Priority: Follow-up action

### Accounts and health

Inspection: grp02_readonly; application query: event_app; maintenance candidate: event_owner. NOLOGIN privilege groups: event_app -> grp02_runtime_grp; grp02_readonly -> grp02_readonly_grp. Selected logins have no superuser or role/database creation privileges.

Local snapshot: 9254 kB; 10 tables, 27 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

Version: PostgreSQL 18.6 on x86_64-windows

Selected table school_event_management_db.event: estimated live rows 0, dead rows 50, modifications since analyze 30; last manual analyze None; last autoanalyze None. The statistics are estimates, not exact row counts or a corruption test.

### Logs and maintenance

Restricted account log_directory inspection was denied as expected. Shared historical logs lack reliable project attribution; see log-settings.txt and shared-log-review.json.

ANALYZE and ordinary VACUUM on school_event_management_db.event; 2026-11-07

Permission evidence: account event_owner, table MAINTAIN=True, database owner=False, pg_maintain membership=False. No grant was changed.

Both commands completed without a skipping warning. Related-table ANALYZE, where recorded, addressed inaccurate join estimates. Exact SQL and INFO output: analyze*.txt/sql and vacuum.txt/sql. Other tables were not automatically vacuumed.

### Query plan and interpretation

Source: EventRepository.java:19; JPQL countVenueConflicts translated to SQL; venue 1, today, 08:00-17:00, exclusion 0
Exact SELECT and first EXPLAIN: explain.sql/txt. Runtime evidence: plan-before.txt and plan-after.txt.

### Observed plan after the last authorized action

```text
Aggregate: estimated 1, actual 1.0, loops 1
Seq Scan on event: estimated 1, actual 0.0, loops 1
```

Plan excerpt lists the root and table-access nodes; full tree and buffers are preserved in the JSON plan file.

Execution time before: 2.531 ms; after: 0.054 ms. These are single observations, not evidence of a measured speedup. Cache and scheduling can change timings.

### Recommendation and limits

The event conflict query uses an existing index. The local event table is empty after previous test cleanup, so its plan cannot establish behavior at realistic event volume. Keep the existing overlap constraint/index; benchmark realistic dates and venues before considering another index. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Evidence folder: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-maintenance/group-02
Feedback: No - drafted for owner review; not sent

## G03 PAWPAW Veterinary

Repository: https://github.com/rubiakylashane/GRP03_PAWPAW
Snapshot: Earlier local checkout; tested revision not established

Database/schema: group3_Pawpaw / public
Result: Not reachable | Priority: Immediate action

### Accounts and health

Inspection: pawpaw_app; application query: pawpaw_app; maintenance candidate: pawpaw_app. Not verified this activity; prior metadata audit only.

The client returned fe_sendauth: no password supplied. This is an authentication-configuration blocker, not evidence that PostgreSQL is down.

### Logs and maintenance

Current connection.txt reports a missing client password. Shared historical errors are not reliably attributable to this project unless the line identifies the account or database. The database was not inspected through an administrator workaround. Historical example: 2026-11-06 00:29:07 CST FATAL password authentication failed for user pawpaw_app.

Not run - intended-account authentication unavailable

### Recommendation and limits

Securely configure the original Activity 4 application-account password and finish the unresolved access-control plan; then rerun monitoring. Do not reset another project or use postgres to bypass the account.

Evidence folder: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-maintenance/group-03
Feedback: No - drafted for owner review; not sent

## G04 HealthBridge Clinic

Repository: https://github.com/RainneQuintab/GRP03_PROJECTDB
Snapshot: main / 2e5abb5440c1e2f7cadc364352a598ca220c7bc7

Database/schema: grp03_projectdb / public
Result: Healthy | Priority: Follow-up action

### Accounts and health

Inspection: hb_report; application query: hb_app; maintenance candidate: hb_maintenance. NOLOGIN privilege groups: hb_app -> hb_staff; hb_maintenance -> hb_admin; hb_report -> hb_readonly_grp. Selected logins have no superuser or role/database creation privileges.

Local snapshot: 8886 kB; 11 tables, 22 indexes, 2 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

Version: PostgreSQL 18.6 on x86_64-windows

Selected table public.appointments: estimated live rows 2, dead rows 3, modifications since analyze 5; last manual analyze None; last autoanalyze None. The statistics are estimates, not exact row counts or a corruption test.

### Logs and maintenance

Restricted account log_directory inspection was denied as expected. Shared historical logs lack reliable project attribution; see log-settings.txt and shared-log-review.json.

ANALYZE and ordinary VACUUM on public.appointments; 2026-11-07

Permission evidence: account hb_maintenance, table MAINTAIN=True, database owner=False, pg_maintain membership=False. No grant was changed.

Both commands completed without a skipping warning. Related-table ANALYZE, where recorded, addressed inaccurate join estimates. Exact SQL and INFO output: analyze*.txt/sql and vacuum.txt/sql. Other tables were not automatically vacuumed.

### Query plan and interpretation

Source: staff_appointments.php:39; unfiltered appointment listing
Exact SELECT and first EXPLAIN: explain.sql/txt. Runtime evidence: plan-before.txt and plan-after-related.txt.

### Observed plan after the last authorized action

```text
Sort: estimated 2, actual 2.0, loops 1
Seq Scan on specialties: estimated 4, actual 4.0, loops 1
Seq Scan on doctors: estimated 3, actual 3.0, loops 1
Seq Scan on appointments: estimated 2, actual 2.0, loops 1
Seq Scan on patients: estimated 2, actual 2.0, loops 1
```

Plan excerpt lists the root and table-access nodes; full tree and buffers are preserved in the JSON plan file.

Execution time before: 0.301 ms; after: 0.165 ms. These are single observations, not evidence of a measured speedup. Cache and scheduling can change timings.

### Recommendation and limits

Initial join estimates were much larger than the tiny actual tables. ANALYZE on appointments and its patient/doctor/specialty inputs corrected these estimates. Sequential scans and small in-memory joins are reasonable here. For a larger filtered appointment workload, inspect date predicates and existing indexes before adding a date index. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Evidence folder: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-maintenance/group-04
Feedback: No - drafted for owner review; not sent

## G05 SHIORI Cafe

Repository: https://github.com/LeeJnsn27/SHIORIcafe-new
Snapshot: main / 8fab8f7139e3f1d4565e5a600b3f3e5cf1f6cad8

Database/schema: grp10_shioricafedb / shioricafe_schema
Result: Issues found | Priority: Follow-up action

### Accounts and health

Inspection: shiori_report; application query: shiori_app; maintenance candidate: shiori_app. NOLOGIN privilege groups: shiori_app -> shiori_runtime_grp; shiori_report -> shiori_readonly_grp. Selected logins have no superuser or role/database creation privileges.

Local snapshot: 9894 kB; 17 tables, 49 indexes, 3 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

Version: PostgreSQL 18.6 on x86_64-windows

Selected table shioricafe_schema.reservation: estimated live rows 1, dead rows 3, modifications since analyze 7; last manual analyze None; last autoanalyze None. The statistics are estimates, not exact row counts or a corruption test.

### Logs and maintenance

Restricted account log_directory inspection was denied as expected. Shared historical logs lack reliable project attribution; see log-settings.txt and shared-log-review.json.

Withheld - existing account lacks MAINTAIN/ownership; proposed commands supplied

Permission evidence: account shiori_app, table MAINTAIN=False, database owner=False, pg_maintain membership=False. No grant was changed.

Proposed maintenance.sql was not executed: existing privileges do not authorize the operation. Ask the owner for a dedicated table-scoped maintenance role. PostgreSQL was not accessed through a superuser workaround.

### Query plan and interpretation

Source: get-table-occupancy.php:16; active table occupancy
Exact SELECT and first EXPLAIN: explain.sql/txt. Runtime evidence: plan-before.txt and no post-maintenance plan.

### Observed plan before maintenance

```text
Nested Loop: estimated 1, actual 1.0, loops 1
Seq Scan on reservation: estimated 1, actual 1.0, loops 1
Index Scan on customer: estimated 1, actual 1.0, loops 1
```

Plan excerpt lists the root and table-access nodes; full tree and buffers are preserved in the JSON plan file.

Execution time before: 0.092 ms. No maintenance comparison available. These are single observations, not evidence of a measured speedup. Cache and scheduling can change timings.

### Recommendation and limits

The occupancy query scans reservations and probes customer by index. This is reasonable for the small sample. If confirmed bookings become large, evaluate a selective status/time access path against real workload; a new index adds storage and booking-write cost. Maintenance is not currently authorized for this account. Ask the owner to grant table-scoped MAINTAIN to a dedicated NOLOGIN maintenance group and login; keep the application/reporting account unchanged.

Evidence folder: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-maintenance/group-05
Feedback: No - drafted for owner review; not sent

## G06 ByaheRentals / Car Rental

Repository: https://github.com/123airabels/Car_Rental_Management_System
Snapshot: main / ea2cd1691a08cb0e455fc18b398a7570cac1b7ad

Database/schema: car_rental_db / public
Result: Healthy | Priority: Follow-up action

### Accounts and health

Inspection: car_report; application query: app_runtime; maintenance candidate: car_dba. NOLOGIN privilege groups: app_runtime -> car_runtime_grp; car_dba -> car_admin_grp; car_report -> car_readonly_grp. Selected logins have no superuser or role/database creation privileges.

Local snapshot: 9318 kB; 17 tables, 38 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

Version: PostgreSQL 18.6 on x86_64-windows

Selected table public.vehicle: estimated live rows 8, dead rows 2, modifications since analyze 11; last manual analyze None; last autoanalyze None. The statistics are estimates, not exact row counts or a corruption test.

### Logs and maintenance

Restricted account log_directory inspection was denied as expected. Shared historical logs lack reliable project attribution; see log-settings.txt and shared-log-review.json.

ANALYZE and ordinary VACUUM on public.vehicle; 2026-11-07

Permission evidence: account car_dba, table MAINTAIN=True, database owner=False, pg_maintain membership=False. No grant was changed.

Both commands completed without a skipping warning. Related-table ANALYZE, where recorded, addressed inaccurate join estimates. Exact SQL and INFO output: analyze*.txt/sql and vacuum.txt/sql. Other tables were not automatically vacuumed.

### Query plan and interpretation

Source: VehicleController.java:27; list without optional filters
Exact SELECT and first EXPLAIN: explain.sql/txt. Runtime evidence: plan-before.txt and plan-after-related.txt.

### Observed plan after the last authorized action

```text
Sort: estimated 8, actual 8.0, loops 1
Seq Scan on vehicle: estimated 8, actual 8.0, loops 1
Seq Scan on vehicle_category: estimated 4, actual 4.0, loops 1
Seq Scan on rental_rate: estimated 1, actual 1.0, loops 8
```

Plan excerpt lists the root and table-access nodes; full tree and buffers are preserved in the JSON plan file.

Execution time before: 0.328 ms; after: 0.203 ms. These are single observations, not evidence of a measured speedup. Cache and scheduling can change timings.

### Recommendation and limits

The vehicle catalog uses joins, a sort and a per-vehicle correlated rate lookup. Related-table ANALYZE improved estimates. At larger vehicle volume, compare a preselected daily-rate join with the repeated lookup, and inspect existing rental-rate indexes first. Do not add a duplicate index on this small sample. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Evidence folder: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-maintenance/group-06
Feedback: No - drafted for owner review; not sent

## G07 Applicant Management

Repository: https://github.com/mang2mas/grp07-applicant-management-system
Snapshot: main / 2ccec581b94708d5a8f864c353281454dc725fcd

Database/schema: grp07_applicantdb / public
Result: Healthy | Priority: Follow-up action

### Accounts and health

Inspection: grp07_readonly; application query: grp07_app; maintenance candidate: grp07_owner. NOLOGIN privilege groups: grp07_app -> grp07_runtime_grp; grp07_readonly -> grp07_readonly_grp. Selected logins have no superuser or role/database creation privileges.

Local snapshot: 8798 kB; 8 tables, 20 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

Version: PostgreSQL 18.6 on x86_64-windows

Selected table public.department: estimated live rows 5, dead rows 7, modifications since analyze 8; last manual analyze None; last autoanalyze None. The statistics are estimates, not exact row counts or a corruption test.

### Logs and maintenance

Restricted account log_directory inspection was denied as expected. Shared historical logs lack reliable project attribution; see log-settings.txt and shared-log-review.json.

ANALYZE and ordinary VACUUM on public.department; 2026-11-07

Permission evidence: account grp07_owner, table MAINTAIN=True, database owner=True, pg_maintain membership=False. No grant was changed.

Both commands completed without a skipping warning. Related-table ANALYZE, where recorded, addressed inaccurate join estimates. Exact SQL and INFO output: analyze*.txt/sql and vacuum.txt/sql. Other tables were not automatically vacuumed.

### Query plan and interpretation

Source: index.php:20; first page without search
Exact SELECT and first EXPLAIN: explain.sql/txt. Runtime evidence: plan-before.txt and plan-after-related.txt.

### Observed plan after the last authorized action

```text
Limit: estimated 5, actual 5.0, loops 1
Seq Scan on position: estimated 8, actual 8.0, loops 1
Seq Scan on department: estimated 5, actual 5.0, loops 1
```

Plan excerpt lists the root and table-access nodes; full tree and buffers are preserved in the JSON plan file.

Execution time before: 0.607 ms; after: 0.169 ms. These are single observations, not evidence of a measured speedup. Cache and scheduling can change timings.

### Recommendation and limits

The department list joins positions, counts them, sorts names and paginates. Statistics on department and position now reflect the sample better. Existing indexes are adequate here. Leading-wildcard ILIKE searches need separate workload measurement; an ordinary B-tree should not be assumed to fix them. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Evidence folder: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-maintenance/group-07
Feedback: No - drafted for owner review; not sent

## G08 Catering Management

Repository: https://github.com/yami-sumi/catering-management-system
Snapshot: main / a415ead922213f9b559339ab26e17f30924fb1a1

Database/schema: catering_management_db / public
Result: Issues found | Priority: Follow-up action

### Accounts and health

Inspection: catering_report; application query: catering_app; maintenance candidate: catering_app. NOLOGIN privilege groups: catering_app -> catering_runtime_grp; catering_report -> catering_readonly_grp. Selected logins have no superuser or role/database creation privileges.

Local snapshot: 8734 kB; 12 tables, 16 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

Version: PostgreSQL 18.6 on x86_64-windows

Selected table public.package: estimated live rows 3, dead rows 5, modifications since analyze 6; last manual analyze None; last autoanalyze None. The statistics are estimates, not exact row counts or a corruption test.

### Logs and maintenance

Restricted account log_directory inspection was denied as expected. Shared historical logs lack reliable project attribution; see log-settings.txt and shared-log-review.json.

Withheld - existing account lacks MAINTAIN/ownership; proposed commands supplied

Permission evidence: account catering_app, table MAINTAIN=False, database owner=False, pg_maintain membership=False. No grant was changed.

Proposed maintenance.sql was not executed: existing privileges do not authorize the operation. Ask the owner for a dedicated table-scoped maintenance role. PostgreSQL was not accessed through a superuser workaround.

### Query plan and interpretation

Source: customerPortal.js:83; customer package catalog
Exact SELECT and first EXPLAIN: explain.sql/txt. Runtime evidence: plan-before.txt and no post-maintenance plan.

### Observed plan before maintenance

```text
Sort: estimated 270, actual 3.0, loops 1
Seq Scan on package: estimated 270, actual 3.0, loops 1
```

Plan excerpt lists the root and table-access nodes; full tree and buffers are preserved in the JSON plan file.

Execution time before: 0.106 ms. No maintenance comparison available. These are single observations, not evidence of a measured speedup. Cache and scheduling can change timings.

### Recommendation and limits

The package catalog performs a sequential scan and sort. That is reasonable for three sample rows. The estimate was much higher than actual, so the owner should refresh statistics after allowing a suitable maintenance role. No new index is justified by this sample. Ask the owner to grant table-scoped MAINTAIN to a dedicated NOLOGIN maintenance group and login; keep the application/reporting account unchanged.

Evidence folder: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-maintenance/group-08
Feedback: No - drafted for owner review; not sent

## G10 UniSync

Repository: https://github.com/CoffyJosh/unisync
Snapshot: main / c3b916a080f3201567f467a456d55c74b9ca3ba8

Database/schema: grp10_unisyncdb / public
Result: Healthy | Priority: Follow-up action

### Accounts and health

Inspection: unisync_auditor; application query: unisync_app; maintenance candidate: unisync_dba. NOLOGIN privilege groups: unisync_app -> unisync_runtime_grp; unisync_auditor -> unisync_readonly_grp; unisync_dba -> unisync_admin_grp. Selected logins have no superuser or role/database creation privileges.

Local snapshot: 9102 kB; 8 tables, 21 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

Version: PostgreSQL 18.6 on x86_64-windows

Selected table public.registration: estimated live rows 946, dead rows 1, modifications since analyze 2; last manual analyze None; last autoanalyze 2026-11-06T23:21:41.318178+08:00. The statistics are estimates, not exact row counts or a corruption test.

### Logs and maintenance

Restricted account log_directory inspection was denied as expected. Shared historical logs lack reliable project attribution; see log-settings.txt and shared-log-review.json.

ANALYZE and ordinary VACUUM on public.registration; 2026-11-07

Permission evidence: account unisync_dba, table MAINTAIN=True, database owner=False, pg_maintain membership=False. No grant was changed.

Both commands completed without a skipping warning. Related-table ANALYZE, where recorded, addressed inaccurate join estimates. Exact SQL and INFO output: analyze*.txt/sql and vacuum.txt/sql. Other tables were not automatically vacuumed.

### Query plan and interpretation

Source: get_dashboard.php:31; account 1 and empty search
Exact SELECT and first EXPLAIN: explain.sql/txt. Runtime evidence: plan-before.txt and plan-after-related.txt.

### Observed plan after the last authorized action

```text
Aggregate: estimated 1, actual 1.0, loops 1
Seq Scan on organization: estimated 30, actual 30.0, loops 1
Seq Scan on event: estimated 51, actual 51.0, loops 1
Bitmap Heap Scan on registration: estimated 8, actual 9.0, loops 1
```

Plan excerpt lists the root and table-access nodes; full tree and buffers are preserved in the JSON plan file.

Execution time before: 0.408 ms; after: 0.245 ms. These are single observations, not evidence of a measured speedup. Cache and scheduling can change timings.

### Recommendation and limits

The dashboard registration count joins event and organization and filters registrations. Refreshing registration/event/organization statistics improved row estimates. The count query still computes all matches even when the dashboard page is paginated; consider workload and existing account/status/event indexes only if it becomes costly. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Evidence folder: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-maintenance/group-10
Feedback: No - drafted for owner review; not sent

## G11 ReserveIT

Repository: https://github.com/sev-villanueva/ReserveIT-Classroom-and-Material-Reservation-System-
Snapshot: main / dd466cabb7c9628fac386a1e55840fd5f0303334

Database/schema: ReserveIT / public
Result: Healthy | Priority: Follow-up action

### Accounts and health

Inspection: reserveit_reporter; application query: reserveit_app; maintenance candidate: reserveit_owner. NOLOGIN privilege groups: reserveit_app -> app_runtime_grp; reserveit_reporter -> app_readonly_grp. Selected logins have no superuser or role/database creation privileges.

Local snapshot: 9062 kB; 8 tables, 19 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

Version: PostgreSQL 18.6 on x86_64-windows

Selected table public.reservation: estimated live rows 8, dead rows 8, modifications since analyze 15; last manual analyze None; last autoanalyze None. The statistics are estimates, not exact row counts or a corruption test.

### Logs and maintenance

Restricted account log_directory inspection was denied as expected. Shared historical logs lack reliable project attribution; see log-settings.txt and shared-log-review.json.

ANALYZE and ordinary VACUUM on public.reservation; 2026-11-07

Permission evidence: account reserveit_owner, table MAINTAIN=True, database owner=True, pg_maintain membership=False. No grant was changed.

Both commands completed without a skipping warning. Related-table ANALYZE, where recorded, addressed inaccurate join estimates. Exact SQL and INFO output: analyze*.txt/sql and vacuum.txt/sql. Other tables were not automatically vacuumed.

### Query plan and interpretation

Source: main.py:38; staff dashboard status counts
Exact SELECT and first EXPLAIN: explain.sql/txt. Runtime evidence: plan-before.txt and plan-after.txt.

### Observed plan after the last authorized action

```text
Aggregate: estimated 5, actual 5.0, loops 1
Seq Scan on reservation: estimated 8, actual 8.0, loops 1
```

Plan excerpt lists the root and table-access nodes; full tree and buffers are preserved in the JSON plan file.

Execution time before: 13.413 ms; after: 0.124 ms. These are single observations, not evidence of a measured speedup. Cache and scheduling can change timings.

### Recommendation and limits

The dashboard groups all reservations by status. A sequential scan with aggregation is reasonable because every row contributes. ANALYZE corrected the estimate for this small table. An extra status index is not justified merely by the scan; consider summaries only after measuring realistic volumes. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Evidence folder: https://github.com/louisandreidg/Batumbakal-Gym/tree/main/db-maintenance/group-11
Feedback: No - drafted for owner review; not sent

## Shared logs and interpretation

Read-only filesystem review using the authorized local Windows account; restricted database accounts could not inspect log_directory.

Available shared server log files dated 2026-11-06 and 2026-11-07. Severity lines only; SQL statements and parameter details excluded.

Configured log_line_prefix is %t only; shared lines do not identify database/account reliably. Do not assign a shared event to a project without its separate execution record.

| Category | Observed matching severity lines | Meaning |
| locking | 0 | No matching deadlock/timeout severity line in this selected sample. |
| reliability | 0 | No matching PANIC/out-of-space/corruption severity line in this selected sample. |
| connection | 62 | Includes earlier failed authentication and intended cross-database rejections. |
| permission | 152 | Includes deliberate restriction tests and current log-settings denials. |
| constraint | 10 | Includes rejected invalid or referentially inconsistent test writes. |
| schema | 2 | Historical missing schema/import-order failures; not proof of a current outage. |

These are matching lines, not unique incidents. A single event may have multiple log lines. No universal no-error claim is made. The active log may have grown after the review. SQL statements/parameters were excluded to protect credentials and private data. Exact file names and sanitized examples are in shared-log-review.json.

postgresql-2026-11-06_000000.log: 2026-11-06 00:29:07 CST FATAL:  password authentication failed for user "pawpaw_app"

postgresql-2026-11-06_000000.log: 2026-11-06 00:29:07 CST FATAL:  password authentication failed for user "pawpaw_app"

postgresql-2026-11-06_000000.log: 2026-11-06 00:37:46 CST ERROR:  schema "dropboxed" does not exist

postgresql-2026-11-06_000000.log: 2026-11-06 01:22:43 CST FATAL:  pg_hba.conf rejects connection for host "::1", user "event_app", database "dropboxed_db", no encryption

postgresql-2026-11-06_222517.log: 2026-11-06 22:57:52 CST ERROR:  there is no unique constraint matching given keys for referenced table "staff"

Action: ask the server owner to review a privacy-appropriate log prefix with time, database, user and process ID. Do not grant broad settings/statistics visibility to every runtime account. Correlate deliberate Activity 4 denials with execution evidence before treating them as missing application permissions.

## Security and interpretation limits

Other-user query/state visibility can be restricted by PostgreSQL. Every successful health snapshot showed only the collector session in its selected database. This does not prove the application remains available or that no contention happens at other times. Statistics reset times and counters are in health-before.txt. Log visibility is a separate Windows filesystem permission from the database login.

Maintenance used existing database owners or table MAINTAIN privileges. Some original ALL-privilege groups include MAINTAIN in PostgreSQL 18; their observed permission is recorded rather than newly granted. Ordinary VACUUM was run outside transactions with short timeouts. No VACUUM FULL, CLUSTER, REINDEX, index creation, backend cancellation, role change or server logging change was performed.

The selected tables were small, and some were empty. A sequential scan can be the right plan. Recommendations to consider indexes or query rewrites are conditional on realistic workload and existing-index review, with write/storage costs considered. Related-table ANALYZE corrected estimate mismatches. Single before/after timings are not a benchmark.

## Recommendations feedback and submission

| Priority | Action |
| Immediate action | G01/G03: securely configure the intended Activity 4 account credentials, resolve earlier access-control evidence gaps, then rerun inspection. Do not reset passwords or databases without owner direction. |
| Follow-up action | G05/G08: request scoped maintenance access. Other projects: review remaining statistics/dead rows after bulk tests and monitor representative workload. Improve shared log attribution through owner review. |
| No urgent incident established | The visible snapshots and selected log patterns do not establish a current lock, corruption or resource-exhaustion incident. This is limited evidence, not an all-clear guarantee. |

Each project folder includes a specific owner-feedback draft based on its evidence. Activity 5 messages have not been sent and there is no invented feedback date. Existing Activity 4 GitHub issues remain unchanged. Review and approve the messages before sending, then record the actual dates in the tracker.

Activity5-Log-paste-ready.tsv contains the official columns. Paste into a new Activity 5 Log tab, review the group and account details, and edit only Group 09 monitoring rows. The browser could not safely identify its current URL in the earlier tracker attempt, so no live sheet editing was attempted here. The existing Activity 3 row was not modified. Submit this separate Activity 5 PDF and the repository link using the instructor process.

## AI usage declaration

We used AI to read the requirements, prepare monitoring SQL, explain PostgreSQL maintenance privileges, analyze query plans and organize the report. The assistant executed the documented local commands with the existing Activity 4 accounts and retained the actual output. Generated suggestions were checked against PostgreSQL documentation, observed permissions, command completion messages and plan results. AI also drafted owner feedback, but did not send it. We must review the files, understand the commands and submit accurate work.

## Technical references

PostgreSQL 18 VACUUM: https://www.postgresql.org/docs/18/sql-vacuum.html
PostgreSQL 18 monitoring statistics and session visibility: https://www.postgresql.org/docs/18/monitoring-stats.html
PostgreSQL 18 privileges and MAINTAIN: https://www.postgresql.org/docs/18/ddl-priv.html
