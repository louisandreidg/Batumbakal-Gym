# G06 - ByaheRentals / Car Rental

Repository: https://github.com/123airabels/Car_Rental_Management_System

Snapshot: main / ea2cd1691a08cb0e455fc18b398a7570cac1b7ad

Database/schema: car_rental_db / public

Result: Success with issues

Activity 4 status: Privileges tested

Setup needed staff primary-key ordering correction. Application login and vehicle CRUD then worked.

## Setup and objects

Original dump failed at payment_received_by_fkey before staff_pkey. Separate resume script established staff PK first and resumed the fresh import; original seed and supplementary SQL applied.

Seventeen tables including vehicles, rentals, payments, inspections, staff and audit.

## Accounts and access-control plan

All named groups in the table are NOLOGIN except the explicitly described owner/direct-login cases. SIU means SELECT/INSERT/UPDATE; CRUD includes DELETE. Web roles are enforced by application code, separately from these database roles.

| Login or group | Membership/responsibility | Privileges |

|---|---|---|

| app_runtime | car_runtime_grp | SIU operational tables; DELETE vehicle only; audit UPDATE/DELETE denied. |

| car_report | car_readonly_grp | Approved reporting columns; customer/staff password hashes withheld. |

| car_dba | car_admin_grp | Data maintenance; no schema/role/database creation. |

## Representative verification

| Account | Operation | Expected/actual evidence |

|---|---|---|

| app_runtime | Vehicle-category INSERT/UPDATE; audit write | Fixture SIU allowed; audit UPDATE/DELETE denied. |

| Authenticated admin | Vehicle create/update/delete | Actual HTTP operations worked. |

| car_report | Read vehicles; write/read password hash | Read allowed; writes/hash read denied. |

## Limits and issues

Generic roles were mapped to project-specific groups to avoid cluster-wide role collisions. Raw original failure and corrected resume are both retained. No real payments exercised.

## Script provenance

reconstructed-catalog-grants.sql is a read-only catalog-derived reconstruction of existing roles, memberships, database/schema/table/column/sequence ACLs. It is not an original execution log or a complete hardening installer. It omits ownership transfer, function ACLs and default privileges; use the original setup and the supplied plan. Passwords are excluded. final-configuration-audit.txt is administrative metadata, not runtime DML proof.

Previously available original/reconstructed setup scripts and original evidence are retained below this folder. Actual statement/output evidence is referenced in ../verification-results.csv. Account isolation depends on the matching pg_hba snippet, where supplied. Do not replace the server policy wholesale.

## Feedback

Yes - 2026-11-06; https://github.com/123airabels/Car_Rental_Management_System/issues/1
