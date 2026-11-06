# Group 10 — UniSync

Repository: https://github.com/CoffyJosh/unisync
Snapshot: main / c3b916a080f3201567f467a456d55c74b9ca3ba8
Test date: 6 November 2026
Database: grp10_unisyncdb / public
Result: Some Issues

## Tracker notes

Database setup, login, organization/event creation and database permission restrictions worked. Dashboard registration cancellation fails with the restricted runtime account, and Manager permissions differ from the README.

## Verified behavior

- The original schema and sample data initialized successfully in a newly created empty database. The reset statements in init.sql had no existing data to remove. No pre-existing database was reset.
- The documented NOLOGIN groups and three login accounts were created with generated local passwords. Runtime receives SELECT/INSERT/UPDATE and required sequence access, with no DELETE or DDL. The auditor can read approved columns but not account.password_hash. The DBA can maintain data and create schema objects as documented, but has no superuser, role-creation or database-creation attribute.
- Real sample-account logins worked. Creating an organization assigned its creator Admin. A second account joined as Member and was correctly denied organization deletion.
- The Admin created a scheduled event; the Member registered. Event-page unregister used an allowed soft delete. The Admin promoted the Member to Manager, who could publish an event.
- Actual runtime INSERT and UPDATE, DBA INSERT/UPDATE/DELETE, permitted DBA schema creation, auditor reads and denied operations were tested in rollback transactions.
- Runtime physical DELETE was denied on all application tables. Auditor writes, sensitive-column reads and ordinary schema/role/database creation were denied. Actual connections to unrelated databases were rejected.
- A reversed schedule time was refused by the database check constraint.
- Local connection policy names only the UniSync accounts, permits the intended database on localhost, and rejects other database or remote access. Existing project rules were preserved.
- Application source remained unchanged. Test organization/events were soft-deleted through the normal endpoints. A Manager-created test event remains tied to the deleted test organization, consistent with observed SQL state.
- No manual browser walkthrough, map tile service, image upload, email or load test is claimed.

## Confirmed issues

1. Dashboard cancellation: public/assets/javascript/app/dashboard.js calls php/app/dashboard/cancel_registration.php. That handler executes DELETE FROM registration. The documented runtime group deliberately has no DELETE privilege, so the actual authenticated cancellation returned HTTP 500. The event page's unregister action uses UPDATE status='deleted' and succeeded. Recommended fix: make dashboard cancellation use the same soft-delete policy; do not widen the runtime role merely to hide the mismatch.

2. Manager authorization: README limits editing/deleting organization details to organization Admins, but update_organization.php accepts Admin or Manager. After normal promotion to Manager, the second account successfully changed the university_name instead of receiving the documented denial. database-inventory.txt confirms the changed field. Align the implementation and role documentation.

3. Bare PHP configuration: the login handler emits leading output before headers. With output buffering off, warnings corrupted its JSON response and session regeneration failed. The same sample credentials returned success after configuring normal output buffering. The initial response is preserved. Remove leading output and keep errors out of API responses rather than depending on buffering.

## Evidence and provenance

application-results.json records actual HTTP outcomes; the two functional expectation failures are retained.
permission-results.json records account, SQL, database, expected/actual result and actual output.
roles-from-documentation.sql is the documented setup with secret placeholders removed, not a complete unattended credential provisioner. Passwords were assigned locally and are excluded.
connection-policy.snippet is the applied localhost-only account restriction.
database-inventory.txt and soft-delete-state.txt show objects, memberships and test state.
setup.log is the actual setup output.

Feedback is drafted below, not sent. The Google tracker has not been edited.

## Feedback draft

UniSync initialized and worked with the documented restricted database accounts. Dashboard cancellation attempts a physical DELETE and fails because the runtime role correctly lacks DELETE; please use a soft delete as the event page does. Manager organization-edit permissions also differ from the README. The login handler should avoid output before response headers.

