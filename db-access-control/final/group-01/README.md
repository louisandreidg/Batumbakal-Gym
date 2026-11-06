# G01 - DropBoxed

Repository: https://github.com/joshxaaaaaa/GRP1_Dropboxed

Snapshot: Earlier local ZIP; revision not established

Database/schema: dropboxed_db / dropboxed

Result: Success with issues

Activity 4 status: Planning

Existing objects and direct grants confirmed. Original restricted-login CRUD evidence was not recovered.

## Setup and objects

Existing database retained. Administrative catalog audit only; no schema reset or credential change.

Eight tables including users, complaints, assignments, attachments and status_logs.

## Accounts and access-control plan

All named groups in the table are NOLOGIN except the explicitly described owner/direct-login cases. SIU means SELECT/INSERT/UPDATE; CRUD includes DELETE. Web roles are enforced by application code, separately from these database roles.

| Login or group | Membership/responsibility | Privileges |

|---|---|---|

| dropboxed_app | No evidenced NOLOGIN group | Direct table CRUD; non-superuser, no role/database creation. Broad grants need review. |

## Representative verification

| Account | Operation | Expected/actual evidence |

|---|---|---|

| postgres | Inspect objects and grants | Inventory returned; administrative metadata only. |

| dropboxed_app | Password-free login attempt | No password supplied; does not verify an intended-account operation. |

## Limits and issues

Tracker previously says Success. Current evidence supports setup metadata only. Tested local source was Downloads/Dropboxed-main (earlier identified as jedelacruz/Dropboxed); identity against registry repo is unverified. NOLOGIN/read-only/isolation and fresh restricted-account operations remain outstanding.

## Script provenance

reconstructed-catalog-grants.sql is a read-only catalog-derived reconstruction of existing roles, memberships, database/schema/table/column/sequence ACLs. It is not an original execution log or a complete hardening installer. It omits ownership transfer, function ACLs and default privileges; use the original setup and the supplied plan. Passwords are excluded. final-configuration-audit.txt is administrative metadata, not runtime DML proof.

Previously available original/reconstructed setup scripts and original evidence are retained below this folder. Actual statement/output evidence is referenced in ../verification-results.csv. Account isolation depends on the matching pg_hba snippet, where supplied. Do not replace the server policy wholesale.

## Feedback

No - evidence/implementation gaps remain in our local testing

## Remaining work

Recover or securely configure the original application login, review least-privilege table requirements, add NOLOGIN/runtime/reporting roles and account isolation, and capture actual allowed/denied operations. Existing grants and application data were left unchanged as requested. These are not marked Completed.
