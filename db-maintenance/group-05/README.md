# Activity 5 G05 SHIORI Cafe

Inspection date: 7 November 2026

Repository: https://github.com/LeeJnsn27/SHIORIcafe-new

Snapshot: main / 8fab8f7139e3f1d4565e5a600b3f3e5cf1f6cad8

Database/schema: grp10_shioricafedb / shioricafe_schema

Health: Issues found

Priority: Follow-up action

## Accounts and role confirmation

Inspection: shiori_report. Query: shiori_app. Maintenance candidate: shiori_app. Roles are the existing Activity 4 accounts; no new privilege was granted.

Named logins and inherited NOLOGIN groups match the Activity 4 snapshot. No observed selected login has SUPERUSER, CREATEDB or CREATEROLE. This is a selected-account/catalog comparison, not a full grant re-audit.

## Health and activity

Local snapshot: 9894 kB; 17 tables, 49 indexes, 3 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

## Logs and issue assessment

The restricted inspection account cannot examine log_directory (pg_read_all_settings required). This expected Activity 5 inspection denial is evidenced in log-settings.txt; it is not an application failure. The authorized Windows account separately reviewed available shared severity logs without changing logging settings. log_line_prefix contains only time, so most historical lines cannot be assigned to this database reliably. See ../shared-log-review.json. No ongoing blocking was seen at the sampled instant; that does not exclude past or future waits.

## Maintenance purpose and outcome

Withheld - existing account lacks MAINTAIN/ownership; proposed commands supplied

ANALYZE refreshes planner statistics after test changes. Ordinary VACUUM reclaims dead-row space for reuse and updates visibility information without deleting live records. Standalone commands used short lock/statement timeouts. No VACUUM FULL, index creation, backend termination or logging reconfiguration was performed.

## Query and recommendation

backend/api/get-table-occupancy.php:16; active table occupancy

The occupancy query scans reservations and probes customer by index. This is reasonable for the small sample. If confirmed bookings become large, evaluate a selective status/time access path against real workload; a new index adds storage and booking-write cost. Maintenance is not currently authorized for this account. Ask the owner to grant table-scoped MAINTAIN to a dedicated NOLOGIN maintenance group and login; keep the application/reporting account unchanged.

## Limits

Health, session and statistics values are a point-in-time local test sample. Other users query details may be hidden by PostgreSQL. SQL permissions were not bypassed. The data set is small and no load benchmark or production certification is implied. Earlier Activity 4 functional issues are separate from current database monitoring.

## Feedback

No - drafted for owner review; not sent
