# G03 PAWPAW Veterinary Activity 6

Result: Success with issues

Backup and recovery worked; the existing direct-grant runtime design still needs review.

Database: group3_Pawpaw. Backup: g03_source_run1.dump (46742 bytes), SHA-256 a291ab33eafc17ead8b85c24ad5032071b899b5263ca845fc0476a4fd8176f10.

Initial restore: a6_g03_restore_20261107. Preflight: a6_g03_preflight_20261107. Recovery: a6_g03_recovery_20261107.

The source/restored application-table counts and row fingerprints, sequence states, constraints, indexes, views/functions and runtime/reporting ACLs matched. Existing roles/memberships and mapped default privileges were checked separately. The clone-only verifier inherited pawpaw_app, ran the representative SELECT and was denied schema CREATE. Source access by verifier/restorer and clone access by the backup account were rejected by the account-specific connection policy.

Recovery used a single clearly identified activity6_probe.recovery_record row, never an application table. The checkpoint archive was restored and verified in the preflight copy before deletion in the incident copy. A fresh recovery copy restored after the deletion contained the expected marker. Original application data and the initial archive remained unchanged.

See the case output for the commands and results, backup-metadata.json for archive checksums, and roles-reconstruction.sql for the role plan. Full web workflows were not tested.

Proposed backup interval/RPO: 1 hour. RTO: 1 hour. See backup-plan.md. The original source archive predates the disposable fixture; fixture recovery uses the separate checkpoint archive.

Feedback: drafted, not sent.
