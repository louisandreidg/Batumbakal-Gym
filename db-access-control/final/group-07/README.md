# G07 - Applicant Management

Repository: https://github.com/mang2mas/grp07-applicant-management-system

Snapshot: main / 2ccec581b94708d5a8f864c353281454dc725fcd

Database/schema: grp07_applicantdb / public

Result: Success

Activity 4 status: Privileges tested

Setup, pages, department CRUD, validation, CSRF and restricted SQL worked.

## Setup and objects

Original db/01_schema.sql and db/02_seed.sql applied as grp07_owner. Local PHP/session configuration only.

Eight tables: department, position, applicant, application_status, application, interview, requirement, applicant_requirement.

## Accounts and access-control plan

All named groups in the table are NOLOGIN except the explicitly described owner/direct-login cases. SIU means SELECT/INSERT/UPDATE; CRUD includes DELETE. Web roles are enforced by application code, separately from these database roles.

| Login or group | Membership/responsibility | Privileges |

|---|---|---|

| grp07_owner | Object owner | Owns database/objects; no superuser or role/database creation. |

| grp07_app | grp07_runtime_grp | CRUD operational tables; SELECT only application_status; sequence USAGE. |

| grp07_readonly | grp07_readonly_grp | SELECT eight tables; no writes or schema CREATE. |

## Representative verification

| Account | Operation | Expected/actual evidence |

|---|---|---|

| grp07_app | Temporary department CRUD | Actual allowed operations; rolled back. |

| grp07_app | Write application_status; schema/role creation | Denied as expected. |

| grp07_readonly | Read tables; INSERT/UPDATE/DELETE | Read allowed; writes denied. |

## Limits and issues

Reporting is a database account, not a web user. Future reporting SELECT is configured under grp07_owner; runtime future-object grants need review.

## Script provenance

reconstructed-catalog-grants.sql is a read-only catalog-derived reconstruction of existing roles, memberships, database/schema/table/column/sequence ACLs. It is not an original execution log or a complete hardening installer. It omits ownership transfer, function ACLs and default privileges; use the original setup and the supplied plan. Passwords are excluded. final-configuration-audit.txt is administrative metadata, not runtime DML proof.

Previously available original/reconstructed setup scripts and original evidence are retained below this folder. Actual statement/output evidence is referenced in ../verification-results.csv. Account isolation depends on the matching pg_hba snippet, where supplied. Do not replace the server policy wholesale.

## Feedback

No - no new owner correction identified
