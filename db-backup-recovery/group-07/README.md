# G07 Applicant Management Activity 6

Result: Success with issues

Backup and recovery worked after mapping owner-specific default privileges to the test owner.

Database: grp07_applicantdb. Backup: g07_source_run1.dump (36062 bytes), SHA-256 05fe1275647799460bba767e93abc8b2f18ff2026d54b965b26e46b3cbe1dd93.

Initial restore: a6_g07_restore_20261107. Preflight: a6_g07_preflight_20261107. Recovery: a6_g07_recovery_20261107.

The source/restored application-table counts and row fingerprints, sequence states, constraints, indexes, views/functions and runtime/reporting ACLs matched. Existing roles/memberships and mapped default privileges were checked separately. The clone-only verifier inherited grp07_app, ran the representative SELECT and was denied schema CREATE. Source access by verifier/restorer and clone access by the backup account were rejected by the account-specific connection policy.

Recovery used a single clearly identified activity6_probe.recovery_record row, never an application table. The checkpoint archive was restored and verified in the preflight copy before deletion in the incident copy. A fresh recovery copy restored after the deletion contained the expected marker. Original application data and the initial archive remained unchanged.

Actual SQL and command output are retained with their run labels. Earlier failed checks/restores remain for traceability; the final successful test is run3. backup-metadata.json records both archive checksums. roles-reconstruction.sql is a secret-free fresh-cluster prerequisite, not an executed creation of roles that already existed. Default privilege mappings are in the explicit replay SQL files. Full web workflows were not exercised.

Proposed backup interval/RPO: 24 hour(s). RTO: 4 hour(s). See backup-plan.md. The original source archive predates the disposable fixture; fixture recovery uses the separate checkpoint archive.

Feedback: drafted, not sent.
