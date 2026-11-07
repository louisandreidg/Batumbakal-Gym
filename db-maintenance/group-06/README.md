# Activity 5 G06 ByaheRentals / Car Rental

Inspection date: 7 November 2026

Repository: https://github.com/123airabels/Car_Rental_Management_System

Snapshot: main / ea2cd1691a08cb0e455fc18b398a7570cac1b7ad

Database/schema: car_rental_db / public

Health: Healthy

Priority: Follow-up action

## Accounts and role confirmation

Inspection: car_report. Query: app_runtime. Maintenance candidate: car_dba. 

Named logins and inherited NOLOGIN groups match the Activity 4 snapshot. No observed selected login has SUPERUSER, CREATEDB or CREATEROLE. 

## Health and activity

Local snapshot: 9318 kB; 17 tables, 38 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. 

## Logs and issue assessment

The restricted inspection account cannot examine log_directory (pg_read_all_settings required). The permission denial is saved in log-settings.txt. The authorized Windows account separately reviewed available shared severity logs without changing logging settings. log_line_prefix contains only time, so most historical lines cannot be assigned to this database reliably. See ../shared-log-review.json. No ongoing blocking was seen at the sampled instant; that does not exclude past or future waits.

## Maintenance purpose and outcome

ANALYZE and ordinary VACUUM on public.vehicle; 2026-11-07

ANALYZE refreshes planner statistics after test changes. Ordinary VACUUM reclaims dead-row space for reuse and updates visibility information without deleting live records. Standalone commands used short lock/statement timeouts. No VACUUM FULL, index creation, backend termination or logging reconfiguration was performed.

## Query and recommendation

Application/src/main/java/com/carrental/car_rental_app/web/VehicleController.java:27; list without optional filters

The vehicle catalog uses joins, a sort and a per-vehicle correlated rate lookup. Related-table ANALYZE improved estimates. At larger vehicle volume, compare a preselected daily-rate join with the repeated lookup, and inspect existing rental-rate indexes first. Do not add a duplicate index on this small sample. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

## Limits

These checks cover the local test database at the recorded time. See the activity README for shared log and timing limitations.

## Feedback

Drafted, not sent.
