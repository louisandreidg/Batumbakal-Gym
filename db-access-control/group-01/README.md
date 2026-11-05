# Supplementary earlier work: Group 01 Dropboxed

These are earlier tracker records, not part of the four newly confirmed project reports. The tracker currently records Success. This session confirms existing database objects and grants through an administrative configuration audit only.

Database: dropboxed_db. Existing login: dropboxed_app; no SUPERUSER, CREATEDB or CREATEROLE. Current account has table CRUD directly, without an evidenced NOLOGIN privilege group. PUBLIC CONNECT on the database remains enabled. These gaps must not be described as a fully completed least-privilege design.

An actual login attempt without a supplied password returned fe_sendauth: no password supplied. No password reset was attempted. Earlier restricted-account tests are reported in the tracker/conversation; their original operation logs were not recovered. Full application functionality is not newly verified here. configuration-audit.txt proves objects and listed grants, not INSERT/UPDATE/DELETE execution.

reconstructed-current-grants.sql reproduces the audited direct grants for a fresh environment. It is not an original execution record and is not a recommended final least-privilege policy. Review operational-table requirements and add NOLOGIN roles, reporting access and database isolation before marking Activity 4 complete for this project.

Feedback not sent. Suggested feedback: Please review broad direct runtime CRUD grants, audit/history protection and database isolation. 