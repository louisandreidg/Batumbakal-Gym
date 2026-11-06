# Activity 5 G11 ReserveIT

Inspection date: 7 November 2026

Repository: https://github.com/sev-villanueva/ReserveIT-Classroom-and-Material-Reservation-System-

Snapshot: main / dd466cabb7c9628fac386a1e55840fd5f0303334

Database/schema: ReserveIT / public

Health: Healthy

Priority: Follow-up action

## Accounts and role confirmation

Inspection: reserveit_reporter. Query: reserveit_app. Maintenance candidate: reserveit_owner. Roles are the existing Activity 4 accounts; no new privilege was granted.

Named logins and inherited NOLOGIN groups match the Activity 4 snapshot. No observed selected login has SUPERUSER, CREATEDB or CREATEROLE. This is a selected-account/catalog comparison, not a full grant re-audit.

## Health and activity

Local snapshot: 9062 kB; 8 tables, 19 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

## Logs and issue assessment

The restricted inspection account cannot examine log_directory (pg_read_all_settings required). This expected Activity 5 inspection denial is evidenced in log-settings.txt; it is not an application failure. The authorized Windows account separately reviewed available shared severity logs without changing logging settings. log_line_prefix contains only time, so most historical lines cannot be assigned to this database reliably. See ../shared-log-review.json. No ongoing blocking was seen at the sampled instant; that does not exclude past or future waits.

## Maintenance purpose and outcome

ANALYZE and ordinary VACUUM on public.reservation; 2026-11-07

ANALYZE refreshes planner statistics after test changes. Ordinary VACUUM reclaims dead-row space for reuse and updates visibility information without deleting live records. Standalone commands used short lock/statement timeouts. No VACUUM FULL, index creation, backend termination or logging reconfiguration was performed.

## Query and recommendation

app/main.py:38; staff dashboard status counts

The dashboard groups all reservations by status. A sequential scan with aggregation is reasonable because every row contributes. ANALYZE corrected the estimate for this small table. An extra status index is not justified merely by the scan; consider summaries only after measuring realistic volumes. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

## Limits

Health, session and statistics values are a point-in-time local test sample. Other users query details may be hidden by PostgreSQL. SQL permissions were not bypassed. The data set is small and no load benchmark or production certification is implied. Earlier Activity 4 functional issues are separate from current database monitoring.

## Feedback

No - drafted for owner review; not sent
