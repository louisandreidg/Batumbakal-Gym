# Activity 5 G02 Eventer / School Event Management

Inspection date: 7 November 2026

Repository: https://github.com/JosephEmmanuelBabas/School_Event_Management_Web_Appli

Snapshot: main ZIP; commit unavailable; SHA256 B251FC9C32CECF3090C7AC0ED14EF11862BE29E89656947DBF3A6F00B86569B3

Database/schema: grp02_event_management_db / school_event_management_db

Health: Healthy

Priority: Follow-up action

## Accounts and role confirmation

Inspection: grp02_readonly. Query: event_app. Maintenance candidate: event_owner. Roles are the existing Activity 4 accounts; no new privilege was granted.

Named logins and inherited NOLOGIN groups match the Activity 4 snapshot. No observed selected login has SUPERUSER, CREATEDB or CREATEROLE. This is a selected-account/catalog comparison, not a full grant re-audit.

## Health and activity

Local snapshot: 9254 kB; 10 tables, 27 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. These counters are cumulative and a single snapshot does not establish sustained health.

## Logs and issue assessment

The restricted inspection account cannot examine log_directory (pg_read_all_settings required). This expected Activity 5 inspection denial is evidenced in log-settings.txt; it is not an application failure. The authorized Windows account separately reviewed available shared severity logs without changing logging settings. log_line_prefix contains only time, so most historical lines cannot be assigned to this database reliably. See ../shared-log-review.json. No ongoing blocking was seen at the sampled instant; that does not exclude past or future waits.

## Maintenance purpose and outcome

ANALYZE and ordinary VACUUM on school_event_management_db.event; 2026-11-07

ANALYZE refreshes planner statistics after test changes. Ordinary VACUUM reclaims dead-row space for reuse and updates visibility information without deleting live records. Standalone commands used short lock/statement timeouts. No VACUUM FULL, index creation, backend termination or logging reconfiguration was performed.

## Query and recommendation

school_event_management/src/main/java/com/school_event/school_event_management/repository/EventRepository.java:19; JPQL countVenueConflicts translated to SQL; venue 1, today, 08:00-17:00, exclusion 0

The event conflict query uses an existing index. The local event table is empty after previous test cleanup, so its plan cannot establish behavior at realistic event volume. Keep the existing overlap constraint/index; benchmark realistic dates and venues before considering another index. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

## Limits

Health, session and statistics values are a point-in-time local test sample. Other users query details may be hidden by PostgreSQL. SQL permissions were not bypassed. The data set is small and no load benchmark or production certification is implied. Earlier Activity 4 functional issues are separate from current database monitoring.

## Feedback

No - drafted for owner review; not sent
