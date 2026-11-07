# Activity 5 G07 Applicant Management

Inspection date: 7 November 2026

Repository: https://github.com/mang2mas/grp07-applicant-management-system

Snapshot: main / 2ccec581b94708d5a8f864c353281454dc725fcd

Database/schema: grp07_applicantdb / public

Health: Healthy

Priority: Follow-up action

## Accounts and role confirmation

Inspection: grp07_readonly. Query: grp07_app. Maintenance candidate: grp07_owner. 

Named logins and inherited NOLOGIN groups match the Activity 4 snapshot. No observed selected login has SUPERUSER, CREATEDB or CREATEROLE. 

## Health and activity

Local snapshot: 8798 kB; 8 tables, 20 indexes, 0 views. Other sessions visible: 0; visible blocked sessions: 0. Database deadlocks counter: 0; checksum failures counter: 0. Autovacuum is on. 

## Logs and issue assessment

The restricted inspection account cannot examine log_directory (pg_read_all_settings required). The permission denial is saved in log-settings.txt. The authorized Windows account separately reviewed available shared severity logs without changing logging settings. log_line_prefix contains only time, so most historical lines cannot be assigned to this database reliably. See ../shared-log-review.json. No ongoing blocking was seen at the sampled instant; that does not exclude past or future waits.

## Maintenance purpose and outcome

ANALYZE and ordinary VACUUM on public.department; 2026-11-07

ANALYZE refreshes planner statistics after test changes. Ordinary VACUUM reclaims dead-row space for reuse and updates visibility information without deleting live records. Standalone commands used short lock/statement timeouts. No VACUUM FULL, index creation, backend termination or logging reconfiguration was performed.

## Query and recommendation

src/views/departments/index.php:20; first page without search

The department list joins positions, counts them, sorts names and paginates. Statistics on department and position now reflect the sample better. Existing indexes are adequate here. Leading-wildcard ILIKE searches need separate workload measurement; an ordinary B-tree should not be assumed to fix them. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

## Limits

These checks cover the local test database at the recorded time. See the activity README for shared log and timing limitations.

## Feedback

Drafted, not sent.
