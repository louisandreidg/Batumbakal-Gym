# Additional Activity 4 testing — 6 November 2026

These results use the latest snapshots checked in this testing session. They supersede the earlier SHIORI assessment for the older snapshot. No other group's source code was modified.

| Project | Result | Short notes |
|---|---|---|
| HealthBridge Clinic Management System | Success | PostgreSQL setup, patient/staff/doctor/admin logins, appointment booking, conflict rejection and cancellation worked. Database CRUD and restricted-account permissions passed. |
| SHIORI Cafe | Some Issues | PostgreSQL setup and manager login now work. The supplied cashier workflow tests fail and reference missing handler paths. |
| ByaheRentals — Car Rental Management System | Some Issues | Application login, vehicle CRUD and database permissions worked after correcting the schema order: the payment foreign key was declared before the staff primary key. |
| Catering Business Management System | Some Issues | Admin/customer login, bookings, CRUD and restricted database access worked. Session storage needed owner setup, and reporting grants were tightened to hide password hashes. |

## Setup changes and evidence limits

- HealthBridge followed the original schema/seed/roles/update/view/demo order. Its runtime uses hb_staff; an independent reporting account and a maintenance login were added.
- SHIORI snapshot 8fab8f7 uses PDO/PostgreSQL; the earlier c8ee5a2 MySQL blocker no longer applies. Original migrations and seed succeeded. The original test runner reports failures despite exiting with status zero, so the result is based on its reported failures rather than its exit code. Authenticated manager HTTP pages worked; the failed cashier suite is not claimed as passed.
- Car rental's schema stopped at payment_received_by_fkey because staff_pkey is declared later. A separate resume script moved that prerequisite earlier and resumed the fresh test schema without deleting data. Original application source stayed unchanged. Backend context test, authenticated catalog access and real vehicle create/update/delete then passed.
- Car-rental and Catering role names were made project-specific in local setup to avoid inheriting ReserveIT's existing global role memberships. Prior projects and grants were unchanged.
- Catering's original identity-based package insert already worked before the added explicit sequence grant. Do not report a sequence-permission failure. Its session table was provisioned by the database administrator so the runtime account did not need schema CREATE. Reporting access to customer/admin password hashes was revoked and approved columns were granted instead.
- Actual runtime INSERT/UPDATE/DELETE affected temporary rows inside rollback transactions. Reporting writes, sensitive-column reads, schema modification and role/database creation were denied where expected.
- Local connection rules name only the new test accounts, allow their own databases on localhost and reject their other/remote connections. Existing rules remain intact.
- Application-created demo accounts/bookings/audit and backup records remain only in these new local test databases. No prior project database or application data was deleted.
- External email/SMS and real payments were not exercised. No manual browser walkthrough or accessibility test is claimed.
- Feedback has not been sent and the Google tracker has not been edited by the assistant.

The previous PDF is a historical snapshot. Consolidate these new results into the final progress report after the remaining class projects are tested.

