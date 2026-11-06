# G08 - Catering Management

Repository: https://github.com/yami-sumi/catering-management-system

Snapshot: main / a415ead922213f9b559339ab26e17f30924fb1a1

Database/schema: catering_management_db / public

Result: Success with issues

Activity 4 status: Privileges tested

Login, package CRUD and bookings worked after owner session setup and narrower reporting grants.

## Setup and objects

Original schema/seed/roles used with project-specific group names. Owner precreated session storage; reporting table-wide grants on customer/admin replaced with approved columns.

Eleven application tables plus owner-provisioned session table.

## Accounts and access-control plan

All named groups in the table are NOLOGIN except the explicitly described owner/direct-login cases. SIU means SELECT/INSERT/UPDATE; CRUD includes DELETE. Web roles are enforced by application code, separately from these database roles.

| Login or group | Membership/responsibility | Privileges |

|---|---|---|

| catering_app | catering_runtime_grp | Application CRUD and session DML; sequence USAGE; no schema CREATE. |

| catering_report | catering_readonly_grp | Approved reporting tables/columns; customer/admin hashes excluded. |

| catering_admin_grp | NOLOGIN maintenance group | Source maintenance privileges, no independent maintenance login tested. |

## Representative verification

| Account | Operation | Expected/actual evidence |

|---|---|---|

| catering_app | Package fixture INSERT/UPDATE/DELETE | Allowed; actual affected rows; rolled back. |

| catering_report | Read packages; writes/read password hashes | Reads allowed; writes/sensitive reads denied. |

| Admin/customer sessions | Authentication, package CRUD, bookings | Worked through actual HTTP requests. |

## Limits and issues

Original identity-based INSERT worked before explicit sequence USAGE was added; no sequence-permission failure is claimed. Original broad reporting access was corrected locally. Source unchanged.

## Script provenance

reconstructed-catalog-grants.sql is a read-only catalog-derived reconstruction of existing roles, memberships, database/schema/table/column/sequence ACLs. It is not an original execution log or a complete hardening installer. It omits ownership transfer, function ACLs and default privileges; use the original setup and the supplied plan. Passwords are excluded. final-configuration-audit.txt is administrative metadata, not runtime DML proof.

Previously available original/reconstructed setup scripts and original evidence are retained below this folder. Actual statement/output evidence is referenced in ../verification-results.csv. Account isolation depends on the matching pg_hba snippet, where supplied. Do not replace the server policy wholesale.

## Feedback

Yes - 2026-11-06; https://github.com/yami-sumi/catering-management-system/issues/1
