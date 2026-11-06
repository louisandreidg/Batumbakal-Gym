-- Selected target: shioricafe_schema.reservation. Review health-before.txt and maintenance-permission.txt first.
-- ANALYZE refreshes planner statistics after Activity 4 test writes.
-- Ordinary VACUUM makes dead-row space reusable and updates visibility information.
-- This is a small local test table. No VACUUM FULL, data reset or index creation.
-- Run each statement standalone as shiori_app; use a 2-second lock timeout.
-- If that account lacks ownership/MAINTAIN/database-owner permission, do not run;
-- record the limitation and request a table-scoped maintenance role from its owner.
ANALYZE VERBOSE shioricafe_schema.reservation;
VACUUM (VERBOSE,ANALYZE) shioricafe_schema.reservation;
