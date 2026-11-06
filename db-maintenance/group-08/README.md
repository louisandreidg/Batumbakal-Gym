# Activity 5 G08 Catering Management

Inspection date: 7 November 2026

Repository: https://github.com/yami-sumi/catering-management-system

Snapshot: main / a415ead922213f9b559339ab26e17f30924fb1a1

Database/schema: catering_management_db / public

Health: Issues found

Priority: Follow-up action

## Accounts and role confirmation

Inspection: catering_report. Query: catering_app. Maintenance candidate: catering_app. Roles are the existing Activity 4 accounts; no new privilege was granted.

Named logins and inherited NOLOGIN groups match the Activity 4 snapshot. No observed selected login has SUPERUSER, CREATEDB or CREATEROLE. This is a selected-account/catalog comparison, not a full grant re-audit.

## Health and activity

Local snapshot: 8734 kB; 12 tables, 16 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

## Logs and issue assessment

The restricted inspection account cannot examine log_directory (pg_read_all_settings required). This expected Activity 5 inspection denial is evidenced in log-settings.txt; it is not an application failure. The authorized Windows account separately reviewed available shared severity logs without changing logging settings. log_line_prefix contains only time, so most historical lines cannot be assigned to this database reliably. See ../shared-log-review.json. No ongoing blocking was seen at the sampled instant; that does not exclude past or future waits.

## Maintenance purpose and outcome

Withheld - existing account lacks MAINTAIN/ownership; proposed commands supplied

ANALYZE refreshes planner statistics after test changes. Ordinary VACUUM reclaims dead-row space for reuse and updates visibility information without deleting live records. Standalone commands used short lock/statement timeouts. No VACUUM FULL, index creation, backend termination or logging reconfiguration was performed.

## Query and recommendation

backend/routes/customerPortal.js:83; customer package catalog

The package catalog performs a sequential scan and sort. That is reasonable for three sample rows. The estimate was much higher than actual, so the owner should refresh statistics after allowing a suitable maintenance role. No new index is justified by this sample. Ask the owner to grant table-scoped MAINTAIN to a dedicated NOLOGIN maintenance group and login; keep the application/reporting account unchanged.

## Limits

Health, session and statistics values are a point-in-time local test sample. Other users query details may be hidden by PostgreSQL. SQL permissions were not bypassed. The data set is small and no load benchmark or production certification is implied. Earlier Activity 4 functional issues are separate from current database monitoring.

## Feedback

No - drafted for owner review; not sent
