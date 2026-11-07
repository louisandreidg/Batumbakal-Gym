# G08 Catering Management Activity 6

Result: Success

Backup, restore, access checks and recovery worked.

Database: catering_management_db. Backup: g08_source_run1.dump (36513 bytes), SHA-256 b06a7366da87f2fcdb581e3cf87f8b24350eacbd9a558c50a0429742e19ae6ef.

Initial restore: a6_g08_restore_20261107. Preflight: a6_g08_preflight_20261107. Recovery: a6_g08_recovery_20261107.

The source/restored application-table counts and row fingerprints, sequence states, constraints, indexes, views/functions and runtime/reporting ACLs matched. Existing roles/memberships and mapped default privileges were checked separately. The clone-only verifier inherited catering_app, ran the representative SELECT and was denied schema CREATE. Source access by verifier/restorer and clone access by the backup account were rejected by the account-specific connection policy.

Recovery used a single clearly identified activity6_probe.recovery_record row, never an application table. The checkpoint archive was restored and verified in the preflight copy before deletion in the incident copy. A fresh recovery copy restored after the deletion contained the expected marker. Original application data and the initial archive remained unchanged.

See the case output for the commands and results, backup-metadata.json for archive checksums, and roles-reconstruction.sql for the role plan. Full web workflows were not tested.

Proposed backup interval/RPO: 1 hour. RTO: 2 hours. See backup-plan.md. The original source archive predates the disposable fixture; fixture recovery uses the separate checkpoint archive.

Feedback: drafted, not sent.
