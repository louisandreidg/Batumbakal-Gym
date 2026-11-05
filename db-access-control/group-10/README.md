# Group 10 SHIORI Cafe

Repository: https://github.com/LeeJnsn27/SHIORIcafe-new

Snapshot: main / c8ee5a2daaac8d84d06e9abd70149763cb62e8a6

Test date: 6 November 2026

Database: grp10_shioricafedb (planned; not provisioned)

Database setup result: Failed

Access-control status: Not started

The application still uses MySQL/MySQLi. PostgreSQL integration is unfinished, blocking PostgreSQL application and account testing.

## Accounts and responsibilities

| Login | Group role | Responsibility | Privileges |
|---|---|---|---|
| Not provisioned | Not implemented for testing | Planned PostgreSQL roles | Cannot validate a runtime account against PostgreSQL while active code uses MySQLi. |

## Evidence and script provenance

No PostgreSQL database/account result is claimed. Source inspection confirmed backend/config/db.php calls mysqli_connect and active order/reservation endpoints call mysqli functions. README calls PostgreSQL/PDO a planned migration. The supplied ZIP had the same blocker. No owning-group code or SQL was modified. Source-review.txt is an inspection record, not an application execution log.

Feedback status: Drafted, not sent. No feedback date is claimed.
