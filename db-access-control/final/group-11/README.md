# G11 - ReserveIT

Repository: https://github.com/sev-villanueva/ReserveIT-Classroom-and-Material-Reservation-System-

Snapshot: main / dd466cabb7c9628fac386a1e55840fd5f0303334

Database/schema: ReserveIT / public

Result: Success

Activity 4 status: Privileges tested

Setup and requester/staff/admin flows worked. Column restrictions and prohibited operations were verified.

## Setup and objects

Original manage.py role setup, schema initialization, grants, seed and checks completed. Login page served over HTTP.

Eight tables: department, app_user, staff, room, material, reservation, reservation_material, penalty; sequences and btree_gist.

## Accounts and access-control plan

All named groups in the table are NOLOGIN except the explicitly described owner/direct-login cases. SIU means SELECT/INSERT/UPDATE; CRUD includes DELETE. Web roles are enforced by application code, separately from these database roles.

| Login or group | Membership/responsibility | Privileges |

|---|---|---|

| reserveit_owner | Object owner | Owns database/objects; no superuser or role/database creation. |

| reserveit_app | app_runtime_grp | Required SIU; restricted UPDATE columns; DELETE room/material only. |

| reserveit_reporter | app_readonly_grp | Approved reporting and people columns; emails/password hashes withheld. |

| reserveit_dba | app_admin_grp | Data/sequence maintenance; no schema/role/database creation. |

## Representative verification

| Account | Operation | Expected/actual evidence |

|---|---|---|

| reserveit_app | Temporary material INSERT/UPDATE/DELETE | Actual affected rows observed; rolled back. |

| reserveit_reporter | Approved reads; sensitive people columns/writes | Reads allowed; prohibited operations denied. |

| reserveit_dba | Actual-row UPDATE; schema CREATE | Data UPDATE allowed; schema CREATE denied. |

## Limits and issues

Some supplied access cases use WHERE false and prove statement privileges only. Separate observed actual-row SQL and application state assertions provide data-changing evidence. Full original DB exception text was not retained in every source access case.

## Script provenance

reconstructed-catalog-grants.sql is a read-only catalog-derived reconstruction of existing roles, memberships, database/schema/table/column/sequence ACLs. It is not an original execution log or a complete hardening installer. It omits ownership transfer, function ACLs and default privileges; use the original setup and the supplied plan. Passwords are excluded. final-configuration-audit.txt is administrative metadata, not runtime DML proof.

Previously available original/reconstructed setup scripts and original evidence are retained below this folder. Actual statement/output evidence is referenced in ../verification-results.csv. Account isolation depends on the matching pg_hba snippet, where supplied. Do not replace the server policy wholesale.

## Feedback

No - no new owner correction identified
