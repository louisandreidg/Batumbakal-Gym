# G06 ByaheRentals / Car Rental Activity 6

Result: Success with issues

Backup and recovery worked after mapping owner-specific default privileges to the test owner.

Database: car_rental_db. Backup: g06_source_run1.dump (81697 bytes), SHA-256 93a6621652610f5728c660742191da60df06ddaa9603e11881a0ad2103761f64.

Initial restore: a6_g06_restore_20261107. Preflight: a6_g06_preflight_20261107. Recovery: a6_g06_recovery_20261107.

The source/restored application-table counts and row fingerprints, sequence states, constraints, indexes, views/functions and runtime/reporting ACLs matched. Existing roles/memberships and mapped default privileges were checked separately. The clone-only verifier inherited app_runtime, ran the representative SELECT and was denied schema CREATE. Source access by verifier/restorer and clone access by the backup account were rejected by the account-specific connection policy.

Recovery used a single clearly identified activity6_probe.recovery_record row, never an application table. The checkpoint archive was restored and verified in the preflight copy before deletion in the incident copy. A fresh recovery copy restored after the deletion contained the expected marker. Original application data and the initial archive remained unchanged.

See the case output for the commands and results, backup-metadata.json for archive checksums, and roles-reconstruction.sql for the role plan. Full web workflows were not tested.

Proposed backup interval/RPO: 1 hour. RTO: 2 hours. See backup-plan.md. The original source archive predates the disposable fixture; fixture recovery uses the separate checkpoint archive.

Feedback: drafted, not sent.
