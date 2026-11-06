# Activity 5 G10 UniSync

Inspection date: 7 November 2026

Repository: https://github.com/CoffyJosh/unisync

Snapshot: main / c3b916a080f3201567f467a456d55c74b9ca3ba8

Database/schema: grp10_unisyncdb / public

Health: Healthy

Priority: Follow-up action

## Accounts and role confirmation

Inspection: unisync_auditor. Query: unisync_app. Maintenance candidate: unisync_dba. Roles are the existing Activity 4 accounts; no new privilege was granted.

Named logins and inherited NOLOGIN groups match the Activity 4 snapshot. No observed selected login has SUPERUSER, CREATEDB or CREATEROLE. This is a selected-account/catalog comparison, not a full grant re-audit.

## Health and activity

Local snapshot: 9102 kB; 8 tables, 21 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

## Logs and issue assessment

The restricted inspection account cannot examine log_directory (pg_read_all_settings required). This expected Activity 5 inspection denial is evidenced in log-settings.txt; it is not an application failure. The authorized Windows account separately reviewed available shared severity logs without changing logging settings. log_line_prefix contains only time, so most historical lines cannot be assigned to this database reliably. See ../shared-log-review.json. No ongoing blocking was seen at the sampled instant; that does not exclude past or future waits.

## Maintenance purpose and outcome

ANALYZE and ordinary VACUUM on public.registration; 2026-11-07

ANALYZE refreshes planner statistics after test changes. Ordinary VACUUM reclaims dead-row space for reuse and updates visibility information without deleting live records. Standalone commands used short lock/statement timeouts. No VACUUM FULL, index creation, backend termination or logging reconfiguration was performed.

## Query and recommendation

php/app/dashboard/get_dashboard.php:31; account 1 and empty search

The dashboard registration count joins event and organization and filters registrations. Refreshing registration/event/organization statistics improved row estimates. The count query still computes all matches even when the dashboard page is paginated; consider workload and existing account/status/event indexes only if it becomes costly. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

## Limits

Health, session and statistics values are a point-in-time local test sample. Other users query details may be hidden by PostgreSQL. SQL permissions were not bypassed. The data set is small and no load benchmark or production certification is implied. Earlier Activity 4 functional issues are separate from current database monitoring.

## Feedback

No - drafted for owner review; not sent
