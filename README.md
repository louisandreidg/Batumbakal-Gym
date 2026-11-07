# Batumbakal Gym Membership Management System

A web-based gym management system developed for Activity 3. The application uses Java Spring Boot for its REST API, PostgreSQL for data storage, and HTML, CSS, and JavaScript for its browser interface.

## Technology

- Java 25
- Spring Boot 4.1.2
- Spring Data JPA
- PostgreSQL 18
- HTML, CSS, JavaScript
- Maven Wrapper

## Main features

The application provides record management for:

1. Members
2. Trainers
3. Membership Plans
4. Memberships
5. Payments
6. Classes
7. Class Enrollments
8. Attendance

The browser interface is served by Spring Boot at `http://localhost:8080/`. The REST API is available under `/api`.

## Requirements

Install Java 25, PostgreSQL, and Git. The included Maven Wrapper downloads and uses the project's configured Maven version.

## Database setup

1. Start PostgreSQL.
2. Create the database:

   ```sql
   CREATE DATABASE grp99_gymdb;
   ```

3. From the project root, run the schema script:

   ```powershell
   psql -U postgres -d grp99_gymdb -f database/schema.sql
   ```

4. Insert the sample data once:

   ```powershell
   psql -U postgres -d grp99_gymdb -f database/seed.sql
   ```

5. Apply the member contact-number uniqueness constraint to an existing database:

   ```powershell
   psql -U postgres -d grp99_gymdb -f database/migrations/001_unique_member_contact_number.sql
   ```

   Apply this migration only once. If the constraint already exists, do not run it again.

`seed.sql` is intended for a fresh database. Do not run it repeatedly on a database that already contains the sample records.

## Database credentials

Do not commit database passwords. The actual password belongs in your local environment, not in this repository.

The project reads these environment variables:

- `DB_URL` — defaults to `jdbc:postgresql://localhost:5432/grp99_gymdb`
- `DB_USERNAME` — defaults to `postgres`
- `DB_PASSWORD` — required

`.env.example` shows the variable names and example values. Spring Boot does not automatically load a `.env` file, so set the variables in your terminal or operating-system environment.

Example for Windows PowerShell (replace the password locally; do not share it):

```powershell
$env:DB_URL="jdbc:postgresql://localhost:5432/grp99_gymdb"
$env:DB_USERNAME="postgres"
$env:DB_PASSWORD="YOUR_LOCAL_DATABASE_PASSWORD"
```

For a safer non-superuser database account, see [Database and Application Roles](docs/ROLES.md).

## Run the application

From the project root in PowerShell:

```powershell
.\mvnw.cmd spring-boot:run
```

Open:

```text
http://localhost:8080/
```

To stop the application, press `Ctrl+C` in the terminal.

## API endpoints

| Module | Endpoint |
|---|---|
| Members | `/api/members` |
| Trainers | `/api/trainers` |
| Membership Plans | `/api/membership-plans` |
| Memberships | `/api/memberships` |
| Payments | `/api/payments` |
| Classes | `/api/classes` |
| Class Enrollments | `/api/class-enrollments` |
| Attendance | `/api/attendance` |

Each module supports the implemented GET, POST, and PUT operations. DELETE behavior depends on the module: member records are deactivated, memberships are cancelled, and the other modules use physical deletion.

## Project structure

```text
database/                  Database schema, seed data, and migrations
docs/                      Project documentation
src/main/java/.../model    JPA entity classes
src/main/java/.../repository
                           Spring Data repositories
src/main/java/.../service  Business logic
src/main/java/.../controller
                           REST API controllers
src/main/resources/static  Browser interface
```

## Known scope and limitations

- The current application does not implement login, authentication, or application-level role-based access control.
- The database role guidance is documented separately; database roles do not create application login screens.
- The frontend uses IDs for related records in several forms. Users must enter valid existing IDs.
- The API currently allows cross-origin requests from any origin through controller annotations; restrict this before production deployment.
- The application is a course project prototype and is not hardened for public production use.

## Documentation

- [Database Design](docs/DATABASE.md)
- [Database and Application Roles](docs/ROLES.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Activity 3 Progress Report](docs/Batumbakal-Gym-Activity3-Progress-Report.pdf)
- [Activity 4 Progress Report](docs/Activity4-Progress-Report-Casilan-de-Guzman.pdf)
- [Activity 5 Progress Report](docs/Activity5-Progress-Report.pdf)
- [Activity 6 Progress Report](docs/Activity6-Progress-Report.pdf)
