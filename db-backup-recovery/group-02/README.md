# G02 Eventer / School Event Management Activity 6

Result: Success

Backup, restore, access checks and recovery worked.

Database: grp02_event_management_db. Backup: g02_source_run1.dump (41905 bytes), SHA-256 95bc72000eaaa89efe88c5b177a475d5eac58d9bd69dab63ebe17ae1ea284293.

Initial restore: a6_g02_restore_20261107. Preflight: a6_g02_preflight_20261107. Recovery: a6_g02_recovery_20261107.

The source/restored application-table counts and row fingerprints, sequence states, constraints, indexes, views/functions and runtime/reporting ACLs matched. Existing roles/memberships and mapped default privileges were checked separately. The clone-only verifier inherited event_app, ran the representative SELECT and was denied schema CREATE. Source access by verifier/restorer and clone access by the backup account were rejected by the account-specific connection policy.

Recovery used a single clearly identified activity6_probe.recovery_record row, never an application table. The checkpoint archive was restored and verified in the preflight copy before deletion in the incident copy. A fresh recovery copy restored after the deletion contained the expected marker. Original application data and the initial archive remained unchanged.

See the case output for the commands and results, backup-metadata.json for archive checksums, and roles-reconstruction.sql for the role plan. Full web workflows were not tested.

Proposed backup interval/RPO: 4 hours. RTO: 2 hours. See backup-plan.md. The original source archive predates the disposable fixture; fixture recovery uses the separate checkpoint archive.

Feedback: drafted, not sent.
