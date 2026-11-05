
# Database and Application Roles

## Important distinction

The current Batumbakal Gym application has no login page, authentication, or application-level role enforcement. The frontend currently exposes the management screens without signing in. Do not describe the application as having working Admin/Staff login roles until authentication and authorization are implemented.

PostgreSQL roles are separate from application user roles. They control database access, not which screens a person can open in the website.

## PostgreSQL Database Roles

The project uses two PostgreSQL accounts with different access permissions:

- `gym_app` – The main application database account. It can read, insert, update, and delete records.
- `gym_readonly` – A read-only account intended for viewing database records and reporting.

For local development, the project may initially connect using the PostgreSQL account configured through `DB_USERNAME` and `DB_PASSWORD`. For a safer setup, use the dedicated `gym_app` account rather than the PostgreSQL superuser.

### Creating the Application Account

Run the following commands as a PostgreSQL administrator while connected to the `grp99_gymdb` database. Replace the sample password with a strong local password. Never commit actual database passwords to the repository.

```sql
CREATE ROLE gym_app LOGIN PASSWORD 'REPLACE_WITH_A_STRONG_PASSWORD';

GRANT CONNECT ON DATABASE grp99_gymdb TO gym_app;
GRANT USAGE ON SCHEMA public TO gym_app;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public TO gym_app;

GRANT USAGE, SELECT, UPDATE
ON ALL SEQUENCES IN SCHEMA public TO gym_app;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO gym_app;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO gym_app;
```

### Creating the Read-Only Account

The following commands create a separate account that can retrieve records but cannot modify them.

```sql
CREATE ROLE gym_readonly LOGIN PASSWORD 'REPLACE_WITH_ANOTHER_STRONG_PASSWORD';

GRANT CONNECT ON DATABASE grp99_gymdb TO gym_readonly;
GRANT USAGE ON SCHEMA public TO gym_readonly;

GRANT SELECT
ON ALL TABLES IN SCHEMA public TO gym_readonly;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT SELECT ON TABLES TO gym_readonly;
```

The default privilege commands assume that `postgres` creates future tables and sequences. If another database role creates them, configure the default privileges for that role instead.

These commands are intended for initial setup. Do not execute the `CREATE ROLE` commands again if the accounts already exist.

## Application Database Configuration

The Spring Boot application reads the following environment variables:

- `DB_URL` – Database connection URL. Defaults to `jdbc:postgresql://localhost:5432/grp99_gymdb`.
- `DB_USERNAME` – PostgreSQL username.
- `DB_PASSWORD` – Password of the selected PostgreSQL account.

For the normal application setup, configure the dedicated `gym_app` account.

Example for Windows PowerShell:

```powershell
$env:DB_URL="jdbc:postgresql://localhost:5432/grp99_gymdb"
$env:DB_USERNAME="gym_app"
$env:DB_PASSWORD="YOUR_LOCAL_DATABASE_PASSWORD"
```

Replace the password with the one configured for the account on the local machine. Spring Boot does not automatically load a `.env` file, so these variables must be set in the terminal or operating-system environment.

The `gym_readonly` account is intended for direct database access and reporting. The current application does not provide a separate read-only web interface.

## Suggested Future Application Roles

If authentication is added in a later version, possible application roles are:

- **Administrator:** Manage members, trainers, plans, memberships, payments, classes, enrollments, and attendance.
- **Staff:** Manage day-to-day member records, check-ins, and class enrollments, with restricted access to sensitive configuration.

These are recommendations only. They are not enforced by the current application code.

## Application-to-Database Role Mapping

| Application Role | Intended Database Role | Access |
|---|---|---|
| Administrator | `gym_app` | Full application database operations |
| Staff | `gym_app` | Restricted operations enforced by the application in a future authenticated version |
| Reporting User | `gym_readonly` | Read-only database access |

The current application uses a shared database connection and does not enforce individual application roles. The mapping above describes the intended design for future authentication and authorization.

## Database Role Verification

The following PostgreSQL roles were created and configured:

| Database Role | Login | Permissions | Verification Status |
|---|---|---|---|
| `gym_app` | Enabled | SELECT, INSERT, UPDATE, DELETE | Passed |
| `gym_readonly` | Enabled | SELECT only | Passed |

### gym_app Verification

The `gym_app` account was tested directly through PostgreSQL.

The following operations were verified:

- SELECT – Allowed.
- INSERT – Allowed.
- UPDATE – Allowed.
- DELETE – Allowed.

A temporary test member record was inserted successfully and subsequently deleted to verify the account's write permissions.

### gym_readonly Verification

The `gym_readonly` account was also tested directly through PostgreSQL.

The following operations were verified:

- SELECT – Allowed.
- INSERT – Denied.
- UPDATE – Denied.
- DELETE – Denied.

The write operations returned PostgreSQL permission-denied errors as expected. No records were modified by the denied operations.

### Database Security Configuration

Both accounts have login access without PostgreSQL superuser privileges.

The `gym_app` account has the permissions needed for the application's database operations, while `gym_readonly` is restricted to retrieving records.

The application is configured to use `gym_app` as its database account instead of the PostgreSQL superuser.

## Security Notes

- Do not use the PostgreSQL superuser for ordinary application access.
- Do not commit database passwords or other credentials to GitHub.
- Use separate database accounts for application operations and read-only access.
- Grant only the permissions required by each account.
- PostgreSQL database roles do not replace application-level authentication or authorization.
- The current system is a course project prototype and is not hardened for public production deployment.
