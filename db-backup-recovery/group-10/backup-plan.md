# G10 UniSync backup plan

Source: grp10_unisyncdb / public. Include all application schemas, table data, sequences, views, functions, indexes, constraints, extensions and object ACLs.

Method: pg_dump custom archive, restored by pg_restore. This allows archive inspection and a complete isolated restore. Store data archives only in the protected local Activity6-Private directory, outside the project repository. NTFS access is limited to the current Windows user and SYSTEM. Compression is not encryption; real deployments should also encrypt and keep an off-device copy.

Accounts: a6_g10_backup inherits SELECT-only a6_g10_backup_grp on this source database. a6_g10_restore owns only the new test databases and has no CREATEDB, CREATEROLE or superuser privilege. a6_g10_verify inherits unisync_app only for verification in the isolated copies. New account-specific localhost rules prevent these logins from reaching other databases. No existing application password or original data is changed.

Restore targets: a6_g10_restore_20261107, a6_g10_preflight_20261107, a6_g10_recovery_20261107. Stop if any target already exists; never overwrite an existing database.

Restoration: use --no-owner to map object ownership to the isolated restore login, preserving object ACL entries. Cluster roles already exist locally; capture secret-free role/membership reconstruction SQL for a fresh cluster before restoring ACLs. Do not export password hashes. Database CONNECT is restricted separately on the new databases. Compare original runtime/reporting ACLs and test actual permitted SELECT plus denied schema CREATE with the clone-only verifier.

Verification: check archive listing and SHA-256, restore to the separate target, compare table row counts and aggregate data fingerprints, sequence states, constraints, indexes, views/functions and representative application-query fingerprints. Source checks before and after detect concurrent data changes. No application rows or password values are printed in evidence.

Simulation: create one labeled record in a new probe schema on the restore copy. Take a separate checkpoint archive. Restore the checkpoint into the preflight copy and verify the probe before deleting it from the incident copy. Delete only that labeled row after checking the exact database/schema. Restore the checkpoint into the fresh recovery database after the incident, then compare the probe and original application data. The initial source archive stays unchanged.

Proposed deployment schedule: back up every 4 hours. Retain the last day of frequent copies, seven daily copies, four weekly copies and three monthly copies; test a restore monthly and after schema changes. Proposed RPO: 4 hours. Proposed RTO: 2 hours. These are planning targets, not measured production guarantees. A snapshot cannot recover writes made after it; shorter loss windows require more frequent backups or a tested WAL/PITR design.
