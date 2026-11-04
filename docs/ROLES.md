# Database and Application Roles

## Important distinction

The current Batumbakal Gym application has no login page, authentication, or application-level role enforcement. The frontend currently exposes the management screens without signing in. Do not describe the application as having working Admin/Staff login roles until authentication and authorization are implemented.

PostgreSQL roles are separate from application user roles. They control database access, not which screens a person can open in the website.

## Suggested PostgreSQL roles

For local development, the project may initially connect using the PostgreSQL account configured through `DB_USERNAME` and `DB_PASSWORD`. For a safer setup, create a dedicated application account rather than using the PostgreSQL superuser.

Run the following as a PostgreSQL administrator. Replace the sample passwords locally before executing; never commit real passwords.

```sql
CREATE ROLE gym_app LOGIN PASSWORD 'REPLACE_WITH_A_STRONG_PASSWORD';
GRANT CONNECT ON DATABASE grp99_gymdb TO gym_app;
GRANT USAGE ON SCHEMA public TO gym_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO gym_app;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO gym_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO gym_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO gym_app;
```

Optional read-only account for reporting:

```sql
CREATE ROLE gym_readonly LOGIN PASSWORD 'REPLACE_WITH_ANOTHER_STRONG_PASSWORD';
GRANT CONNECT ON DATABASE grp99_gymdb TO gym_readonly;
GRANT USAGE ON SCHEMA public TO gym_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO gym_readonly;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO gym_readonly;
```

Set `DB_USERNAME=gym_app` and `DB_PASSWORD` to the locally chosen password when running the application. The read-only role is for direct database/reporting access; the current application does not provide a separate read-only web interface.

## Suggested future application roles

If authentication is added in a later version, possible application roles are:

- Administrator: manage members, trainers, plans, memberships, payments, classes, enrollments, and attendance.
- Staff: manage day-to-day member records, check-ins, and class enrollments, with restricted access to sensitive configuration.

These are recommendations only; they are not enforced by the current code.

## Application-to-Database Role Mapping

| Application Role | Intended Database Role | Access |
|---|---|---|
| Administrator | gym_app | Full application database operations |
| Staff | gym_app | Restricted operations enforced by the application in a future authenticated version |
| Reporting User | gym_readonly | Read-only database access |

The current application uses a shared database connection and does not enforce individual application roles. The mapping above describes the intended design for future authentication and authorization.

## Database Role Verification

The following PostgreSQL roles were created and configured:

| Database Role | Login | Permissions | Status |
|---|---|---|---|
| gym_app | Enabled | SELECT, INSERT, UPDATE, DELETE | Tested successfully |
| gym_readonly | Enabled | SELECT only | Configured |

The gym_app account was tested through the Spring Boot application. Reading, creating, editing, and deactivating member records were successful.

The gym_readonly account is intended for read-only database access.

The application currently uses gym_app as its database account instead of the PostgreSQL superuser.