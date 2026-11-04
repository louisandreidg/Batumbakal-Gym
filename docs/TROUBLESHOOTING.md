# Troubleshooting Guide

## Port 8080 is already in use

Another copy of the application may still be running. Return to the terminal where it is running and press `Ctrl+C`, then start it again:

```powershell
.\mvnw.cmd spring-boot:run
```

## Whitelabel Error Page or 404 at `/`

Confirm that these files exist in the exact location:

```text
src/main/resources/static/index.html
src/main/resources/static/style.css
src/main/resources/static/app.js
```

Restart Spring Boot and open `http://localhost:8080/`.

## Database connection failed

- Confirm PostgreSQL is running.
- Confirm the database `grp99_gymdb` exists.
- Check `DB_URL`, `DB_USERNAME`, and `DB_PASSWORD`.
- Do not put the password in a committed configuration file.
- Confirm the PostgreSQL account has the required database and table permissions.

## Hibernate schema validation failed

The project uses `spring.jpa.hibernate.ddl-auto=validate`. This checks that the existing database schema matches the JPA entities; it does not create or update tables.

Create the database tables using `database/schema.sql`. Do not change `ddl-auto` to `create` or `create-drop` on a database containing data.

## Frontend table is empty or shows an error

- Confirm the Spring Boot application started successfully.
- Open the relevant API endpoint directly, such as `http://localhost:8080/api/members`.
- Check the browser Developer Tools Console and Network tabs.
- Confirm the endpoint path in the frontend matches the controller mapping.

## Duplicate key or unique constraint error

A record may already exist with the same unique email/contact number, or a member may already have an active membership. Check existing database records before retrying.

## Foreign key error

The submitted trainer, member, plan, membership, or class ID may not exist. Check the corresponding list endpoint and use a valid ID.

## Class capacity error

The class may already have reached its configured capacity. Check the class enrollments before trying again.

## Maven cannot write to `target`

Close processes that may be locking project files and check whether antivirus protection is blocking Maven. Retry the Maven command after resolving the file-access issue.
