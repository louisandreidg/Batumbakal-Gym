# G11 ReserveIT Activity 6

Result: Success

Backup, restore, access checks and recovery worked.

Database: ReserveIT. Backup: g11_source_run1.dump (41311 bytes), SHA-256 2361aee2673097130edcf6e88fa474edf0b348ec5ed4301b92ec5fbfd3bd471d.

Initial restore: a6_g11_restore_20261107. Preflight: a6_g11_preflight_20261107. Recovery: a6_g11_recovery_20261107.

The source/restored application-table counts and row fingerprints, sequence states, constraints, indexes, views/functions and runtime/reporting ACLs matched. Existing roles/memberships and mapped default privileges were checked separately. The clone-only verifier inherited reserveit_app, ran the representative SELECT and was denied schema CREATE. Source access by verifier/restorer and clone access by the backup account were rejected by the account-specific connection policy.

Recovery used a single clearly identified activity6_probe.recovery_record row, never an application table. The checkpoint archive was restored and verified in the preflight copy before deletion in the incident copy. A fresh recovery copy restored after the deletion contained the expected marker. Original application data and the initial archive remained unchanged.

Actual SQL and command output are retained with their run labels. Earlier failed checks/restores remain for traceability; the final successful test is run2. backup-metadata.json records both archive checksums. roles-reconstruction.sql is a secret-free fresh-cluster prerequisite, not an executed creation of roles that already existed. Default privilege mappings are in the explicit replay SQL files. Full web workflows were not exercised.

Proposed backup interval/RPO: 1 hour(s). RTO: 1 hour(s). See backup-plan.md. The original source archive predates the disposable fixture; fixture recovery uses the separate checkpoint archive.

Feedback: drafted, not sent.
