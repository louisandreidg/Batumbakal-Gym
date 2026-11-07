# G01 DropBoxed Activity 6

Result: Success with issues

Backup and recovery worked; the existing direct-grant runtime design still needs review.

Database: dropboxed_db. Backup: g01_source_run1.dump (37023 bytes), SHA-256 a2ca8d57473f394263c2208dce1387e5ee686d2c8bbe1bc1ff77acdde1cb3af8.

Initial restore: a6_g01_restore_20261107. Preflight: a6_g01_preflight_20261107. Recovery: a6_g01_recovery_20261107.

The source/restored application-table counts and row fingerprints, sequence states, constraints, indexes, views/functions and runtime/reporting ACLs matched. Existing roles/memberships and mapped default privileges were checked separately. The clone-only verifier inherited dropboxed_app, ran the representative SELECT and was denied schema CREATE. Source access by verifier/restorer and clone access by the backup account were rejected by the account-specific connection policy.

Recovery used a single clearly identified activity6_probe.recovery_record row, never an application table. The checkpoint archive was restored and verified in the preflight copy before deletion in the incident copy. A fresh recovery copy restored after the deletion contained the expected marker. Original application data and the initial archive remained unchanged.

See the case output for the commands and results, backup-metadata.json for archive checksums, and roles-reconstruction.sql for the role plan. Full web workflows were not tested.

Proposed backup interval/RPO: 24 hours. RTO: 4 hours. See backup-plan.md. The original source archive predates the disposable fixture; fixture recovery uses the separate checkpoint archive.

Feedback: drafted, not sent.
