# Setup and testing notes

Use the snapshot in each group README and an empty, separate local database. Do not apply reset/initialization scripts to an existing project. 

1. Original schema and seed: follow the group setup paragraph. G02 uses Flyway V1-V3 as event_owner. G07 uses db/01_schema.sql then db/02_seed.sql as grp07_owner. G11 uses its original manage.py commands and source placeholder scripts.
2. G04 original database directory order: schema.sql, seed.sql, roles.sql, update_reason.sql, update_note_unique.sql, update_billing.sql, create_views.sql, demo_accounts.sql. Additional reporting/maintenance memberships are in the catalog reconstruction.
3. G05 original backend/database/migrations in filename order, then seed.sql. Database names containing 10 are retained from local setup; roster group is 05.
4. G06 original schema needs staff_pkey before payment_received_by_fkey; the included resume SQL records the fresh-import correction. Apply original seed and supplementary payment/inspection SQL afterward. Map generic privilege group names to car_runtime_grp, car_readonly_grp and car_admin_grp.
5. G08 original schema/seed/roles. Map generic groups to catering_runtime_grp, catering_readonly_grp and catering_admin_grp. Owner provisions session storage before runtime. Remove broad reporter SELECT on customer/admin and restore only catalog-listed columns.
6. G10 original db/init.sql and db/seed.sql were used only on a just-created empty database. Do not use init.sql on existing data. roles-from-documentation.sql records the documented plan.
7. Catalog scripts reconstruct final roles/memberships/ACLs. Original schema owners must be established separately. Existing roles cause CREATE ROLE errors: review instead of altering other projects. Use a local password prompt to set LOGIN passwords. No credential file is included. Review PUBLIC baseline revocations together with explicit CONNECT/schema/object grants; catalog scripts alone do not remove extra old privileges.
8. Match each new account to its supplied connection-policy snippet. Snippets depend on server rule order; do not replace pg_hba.conf. Reload and test own-database success plus other-database rejection. G01/G03 have no verified isolation snippet.
9. Tests requiring encrypted CLIXML use local credentials from the testing machine. They are preserved for provenance, not delivered as standalone credential provisioners. shared-tests/test-permissions.ps1 covers G04, G05, G06 and G08. Its result item numbers match verification-results.csv. Configure PSScriptRoot paths/psql location on another machine before running. Do not rerun application test harnesses against real data blindly.

G01/G03 are evidence-limited legacy audits, not completed reconstructions of a least-privilege group design. Their broad existing grants are documented rather than recommended. Existing application passwords and grants were preserved.
