# Reproducing the test

Use a separate local test environment and review project-config.json before running. Original source databases must already exist. Never change a recovery target to a source database.

Set ACTIVITY6_PRIVATE_DIR to a protected directory outside this repository. The provisioning script obtains the authorized local administrator password from PGPASSWORD, creates dedicated backup/restore/verifier roles and new empty target databases, and stores generated credentials only in the private directory. Its role/database-name and policy guards intentionally stop a second provisioning run rather than overwrite an existing setup.

Adapt the PostgreSQL binary and source-project paths for your machine. Review the connection-policy snippet before applying it. Existing application-account rules and passwords must remain unchanged.

Run backup-restore-recovery.ps1 only after reviewing the plans. It preserves custom archives outside the repository, checks empty restore targets, restores object ACLs, maps owner-specific default grants explicitly, verifies a checkpoint restore before deleting one disposable probe, and restores the checkpoint into a fresh recovery target. No clean/drop option is used. Archive hashes are checked before restore.

roles-reconstruction.sql is for a fresh cluster where Activity 4 roles do not yet exist. It omits passwords. In this test those roles already existed; their memberships and privileges were verified, not recreated from a global dump. Object ownership changes only in the isolated copies.

execution-index.json points to the original command/SQL output files. latest-results.json contains each final result; earlier failed comparison/restore logs remain in the project folders. Literal text-array cast rewrites in CHECK expressions are normalized without changing their surrounding logic. Default object grants were audited after owner mapping. All source rows and sequence states matched at the before/after checks.

The application-connection helper uses the original connection modules where practical and private test configuration. It does not test a full web workflow or external files/services. Review feedback drafts before sending them.
