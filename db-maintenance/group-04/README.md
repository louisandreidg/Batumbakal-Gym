# Activity 5 G04 HealthBridge Clinic

Inspection date: 7 November 2026

Repository: https://github.com/RainneQuintab/GRP03_PROJECTDB

Snapshot: main / 2e5abb5440c1e2f7cadc364352a598ca220c7bc7

Database/schema: grp03_projectdb / public

Health: Healthy

Priority: Follow-up action

## Accounts and role confirmation

Inspection: hb_report. Query: hb_app. Maintenance candidate: hb_maintenance. 

Named logins and inherited NOLOGIN groups match the Activity 4 snapshot. No observed selected login has SUPERUSER, CREATEDB or CREATEROLE. 

## Health and activity

Local snapshot: 8886 kB; 11 tables, 22 indexes, 2 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. 

## Logs and issue assessment

The restricted inspection account cannot examine log_directory (pg_read_all_settings required). The permission denial is saved in log-settings.txt. The authorized Windows account separately reviewed available shared severity logs without changing logging settings. log_line_prefix contains only time, so most historical lines cannot be assigned to this database reliably. See ../shared-log-review.json. No ongoing blocking was seen at the sampled instant; that does not exclude past or future waits.

## Maintenance purpose and outcome

ANALYZE and ordinary VACUUM on public.appointments; 2026-11-07

ANALYZE refreshes planner statistics after test changes. Ordinary VACUUM reclaims dead-row space for reuse and updates visibility information without deleting live records. Standalone commands used short lock/statement timeouts. No VACUUM FULL, index creation, backend termination or logging reconfiguration was performed.

## Query and recommendation

backend/staff_appointments.php:39; unfiltered appointment listing

Initial join estimates were much larger than the tiny actual tables. ANALYZE on appointments and its patient/doctor/specialty inputs corrected these estimates. Sequential scans and small in-memory joins are reasonable here. For a larger filtered appointment workload, inspect date predicates and existing indexes before adding a date index. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

## Limits

These checks cover the local test database at the recorded time. See the activity README for shared log and timing limitations.

## Feedback

Drafted, not sent.
