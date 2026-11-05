# Feedback drafts

None of these messages has been sent. Add the actual sent date only after delivery.

## Group 02

Database setup, application workflows and restricted database access worked. Please align docs/user_roles.md with school_event_management_db and actual accounts/group roles. The SQL constraint script referenced by docs/testing.md is missing. We added separate NOLOGIN roles and account-only connection isolation for our Activity 4 test setup.

## Group 07

Database setup, application pages, basic CRUD, validation and CSRF worked. Restricted runtime and reporting accounts behaved as intended after our Activity 4 role setup. Consider documenting those group roles, read-only account and database connection restrictions for future testers.

## Group 10

We could not complete the PostgreSQL setup and application tests because backend/config/db.php and active endpoints still use MySQLi. Please finish the PostgreSQL/PDO migration and provide matching setup, sample data and login instructions so we can retest.

## Group 11

Database setup, requester/staff/admin workflows and documented access restrictions worked. We added account-only connection restrictions in our local PostgreSQL policy to block access to unrelated databases. The access suite includes WHERE false checks; actual data-changing behavior was checked separately. No application source fixes were needed.