# Database Documentation

## Database information

- Database name: `grp99_gymdb`
- DBMS: PostgreSQL
- Schema: `public`
- Setup scripts: `database/schema.sql` and `database/seed.sql`

## Tables and purpose

| Table | Purpose |
|---|---|
| `members` | Stores gym member details and active/inactive status |
| `trainers` | Stores trainer names, specialties, and contact numbers |
| `membership_plans` | Stores available plan names, durations, and prices |
| `memberships` | Connects members to plans and records membership periods/status |
| `payments` | Stores payments made for memberships |
| `classes` | Stores scheduled gym classes and assigned trainers |
| `class_enrollments` | Resolves the many-to-many relationship between members and classes |
| `attendance` | Stores member check-in timestamps |

## Relationships

- A trainer can be assigned to multiple members; a member may have an optional trainer.
- A member can have multiple membership history records. A partial unique index allows only one row with `status = 'Active'` per member.
- Each membership references one membership plan.
- A membership can have multiple payment records.
- Each class references one trainer.
- Members and classes have a many-to-many relationship through `class_enrollments`.
- Each attendance record references one member.

## Important constraints

- Member email is unique.
- Member contact number is required. The migration in `database/migrations/001_unique_member_contact_number.sql` adds its unique constraint to an existing database.
- Membership plan duration must be greater than zero; price cannot be negative.
- Membership end date must be later than start date.
- Only one active membership per member is allowed by the partial unique index.
- Payment amount must be greater than zero.
- Class capacity must be greater than zero; end time must be later than start time.
- A member can enroll in a particular class only once because `(member_id, class_id)` is the composite primary key.
- Foreign keys prevent references to missing parent records.

## Setup and sample data

Run `database/schema.sql` on an empty `grp99_gymdb` database, then run `database/seed.sql` once. The seed script inserts sample trainers, plans, members, memberships, payments, classes, enrollments, and attendance.

For an existing database created before the contact-number migration, apply the migration once. Check for duplicate member contact numbers before applying it.
