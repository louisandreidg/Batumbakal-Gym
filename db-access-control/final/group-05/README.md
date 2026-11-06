# G05 - SHIORI Cafe

Repository: https://github.com/LeeJnsn27/SHIORIcafe-new

Snapshot: main / 8fab8f7139e3f1d4565e5a600b3f3e5cf1f6cad8

Database/schema: grp10_shioricafedb / shioricafe_schema

Result: Success with issues

Activity 4 status: Privileges tested

PostgreSQL and Manager pages work. Supplied cashier workflow tests fail and reference missing handlers.

## Setup and objects

Original migrations 001-005 and seed succeeded; Manager bootstrap used the original utility. Runtime/report groups added locally.

Seventeen tables plus application views/functions.

## Accounts and access-control plan

All named groups in the table are NOLOGIN except the explicitly described owner/direct-login cases. SIU means SELECT/INSERT/UPDATE; CRUD includes DELETE. Web roles are enforced by application code, separately from these database roles.

| Login or group | Membership/responsibility | Privileges |

|---|---|---|

| shiori_app | shiori_runtime_grp | Table CRUD and sequence USAGE; no schema/role/database creation. |

| shiori_report | shiori_readonly_grp | Approved category/menu/table/payment reporting; no staff password-hash access. |

## Representative verification

| Account | Operation | Expected/actual evidence |

|---|---|---|

| shiori_app | Category fixture INSERT/UPDATE/DELETE | Allowed; actual affected rows; rolled back. |

| shiori_report | Read menu; write category/read staff hash | Read allowed; writes and sensitive read denied. |

| Manager HTTP session | Login/pages; supplied cashier suite | Login/pages worked; cashier suite reported failures. |

## Limits and issues

This newer PDO/PostgreSQL snapshot supersedes the historical MySQL-based failure. Runner exits zero despite failed assertions; missing handlers/CSRF failures remain. Database name retains 10, but roster group is 05.

## Script provenance

reconstructed-catalog-grants.sql is a read-only catalog-derived reconstruction of existing roles, memberships, database/schema/table/column/sequence ACLs. It is not an original execution log or a complete hardening installer. It omits ownership transfer, function ACLs and default privileges; use the original setup and the supplied plan. Passwords are excluded. final-configuration-audit.txt is administrative metadata, not runtime DML proof.

Previously available original/reconstructed setup scripts and original evidence are retained below this folder. Actual statement/output evidence is referenced in ../verification-results.csv. Account isolation depends on the matching pg_hba snippet, where supplied. Do not replace the server policy wholesale.

## Feedback

Yes - 2026-11-06; https://github.com/LeeJnsn27/SHIORIcafe-new/issues/1
