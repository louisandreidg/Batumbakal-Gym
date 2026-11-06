# Activity 5 Database Maintenance and Monitoring

Group 09 Batumbakal Gym. Louis Andrei de Guzman and Mark Timothy Casilan. Review date 7 November 2026.

[PDF report](Activity5-Progress-Report.pdf) | [Editable Word report](Activity5-Progress-Report.docx) | [Tracker entries](Activity5-Log-paste-ready.tsv)

Every other roster project has a folder. G01/G03 intended-account authentication remains unavailable and is recorded as Not reachable for this activity; PostgreSQL itself is not claimed down. Maintenance was performed only with existing owner/MAINTAIN permissions. G05/G08 maintenance was withheld. No credentials, role changes, source changes, index creation, VACUUM FULL or superuser workaround is included.

Each folder contains exact inspection SQL/output, query provenance and plans, maintenance permission evidence, performed or proposed commands, log notes and a project report. execution-records.json records the account, timestamp, SQL and command output. plan-before is before maintenance; plan-after-related, where present, follows related-table statistics work. Timings are single cache-sensitive observations, not benchmarks.

The shared log review excludes statement/parameter details. Most historical lines cannot be assigned to databases with the current timestamp-only prefix. Restricted accounts could not read log_directory; their denials are expected and recorded, while the authorized local Windows account reviewed available files read-only.

The collector source is preserved for reproducibility and expects local encrypted credential files that are deliberately excluded. Adapt psql/credential paths for another machine. Do not rerun against production or weaken permissions to force success. The observed MAINTAIN privilege on some original ALL-privilege maintenance groups is evidenced, not newly granted.

Tracker and feedback remain pending: paste the TSV into a new Activity 5 Log tab and edit only this group's rows. The existing Activity 3 row was not changed. All owner messages are clearly labeled drafts; no new public GitHub issue or other message was sent for Activity 5. Send after human review and enter the actual sent date. Final submission through the instructor process remains a user action.

Repository: https://github.com/louisandreidg/Batumbakal-Gym
Tracker: https://docs.google.com/spreadsheets/d/1BClCa9rEs9o-D9Rp3tUZVhECipJ234zX/edit?gid=2123136180

## Activity 4 documentation supplied by the group

The group supplied its own formatted Activity 4 PDF on 7 November 2026. It is preserved unchanged at ../db-access-control/Activity4-Progress-Report-Casilan-de-Guzman.pdf in the repository. The Activity 4 final/ folder retains the underlying SQL and execution evidence. Its stated G01/G03 limitations are consistent with the current authentication blockers.

## Document verification

The PDF was rendered and visually reviewed. The editable Word file was checked for required sections, tables and package integrity. Word pagination could not be rendered locally because LibreOffice is absent; it was not reinstalled, following the user's preference.

## Additional role comparison

role-audit.sql/txt in each reachable project checks all planned accounts and their inherited groups, including planned accounts not selected for the maintenance commands. The check found the planned names present and no selected or planned login with SUPERUSER, CREATEDB or CREATEROLE. Existing privileges were not changed.
