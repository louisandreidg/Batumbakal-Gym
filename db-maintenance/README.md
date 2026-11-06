# Activity 5 Database Maintenance and Monitoring

[Progress PDF](Activity5-Progress-Report.pdf)

Group 9 Batumbakal Gym. Louis Andrei de Guzman and Mark Timothy Casilan. Inspection date 7 November 2026.

The PDF follows the style of the supplied Activity 4 documentation. The editable Word copy is kept locally and is not uploaded.

Each group-XX folder contains monitoring SQL/output, query provenance and plans, maintenance commands, account-permission evidence, log notes and a project report. execution-records.json preserves the account, timestamp, SQL and output; shared-log-review.json contains the scoped log review. No credentials are included.

Existing Activity 4 accounts were used. G01/G03 could not authenticate because intended-account passwords were unavailable. Maintenance was withheld for G05/G08 because existing privileges did not authorize it. Other selected maintenance completed under existing owners or MAINTAIN privileges. No superuser workaround, new grant, reset, VACUUM FULL or index creation was used.

role-audit.sql/txt confirms planned accounts and group memberships in each reachable project. Query timings are single observations affected by cache/scheduling, not a production benchmark. Most shared historical log lines do not reliably identify a database/account.

The scripts expect local encrypted credentials, which are excluded. Adapt psql/credential paths before use; do not weaken privileges or run test harnesses against production. SHA256SUMS.txt covers retained files.

Owner feedback remains explicitly labeled drafts, not sent messages. The live tracker was not edited. Tracker preparation files are kept locally. Enter only this group monitoring rows in the instructor Activity 5 Log and record actual feedback dates after review and delivery.

[Activity 4 documentation](../db-access-control/Activity4-Progress-Report-Casilan-de-Guzman.pdf) is linked above. Its final/ folder retains prior SQL and testing evidence. G01/G03 access limitations remain consistent across both activities.
