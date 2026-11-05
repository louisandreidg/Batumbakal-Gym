# Group 09 Activity 4 submission

Date: 6 November 2026
Members: Louis Andrei de Guzman; Mark Timothy Casilan (names from the existing gym progress draft).
Repository: https://github.com/louisandreidg/Batumbakal-Gym
Tracker: https://docs.google.com/spreadsheets/d/1BClCa9rEs9o-D9Rp3tUZVhECipJ234zX/edit?gid=2123136180

The main report covers the four projects confirmed by the user: Group 02, Group 07,
Group 10, and Group 11. Group 10 is blocked by its unfinished PostgreSQL migration.
Earlier G01/G03 tracker records are included as supplementary configuration audits,
with missing original execution evidence identified. No pass is invented.

## Files and evidence

Activity4-Progress-Report.pdf is the main report.
Activity4-Progress-Report.md is the editable text source.
db-access-control/group-XX contains role plans, SQL scripts and actual evidence.
verification-results.csv maps database account, statement, expected/actual result,
evidence and the distinction between zero-row checks and actual data changes.
feedback-ready-to-send.md contains unsent feedback.
Activity4-Log-paste-ready.tsv has the official eight-column log.
legacy-tracker-notes.txt supplies short notes for the existing six-column sheet.

Original logs and reconstructed scripts are labeled. Credential files, .env files,
passwords, local pg_hba backups and unrelated application files are excluded.
NOLOGIN group roles, schema/table/sequence privileges, account attributes, database
isolation and denied operations are evidenced for G02/G07/G11.

## Submission status and limitations

Technical verification is complete to the documented scope for G02/G07/G11.
SHIORI could not be tested as a PostgreSQL application. It remains Failed.
G01/G03 are historical results with configuration-only audits recovered here;
NOLOGIN memberships, reporting accounts and complete operation evidence are not
established by those audits. All other class projects are outside this package.
Do not claim the whole-class checklist is complete.

Feedback is drafted, not sent. Tracker entries are prepared, not submitted.
After the Git commit/push succeeds, the folder/PDF URLs in the TSV will point to
the submitted material. Publication itself does not prove class-sheet edits or
professor receipt. No additional repository, tracker or feedback completion is
claimed by this README.

The direct PDF renderer uses ReportLab and requires no LibreOffice installation.
Editable Markdown is included; no new DOCX conversion was attempted.

## AI usage

We used ChatGPT/Codex to help understand the instructions, explain PostgreSQL roles
and permissions, prepare SQL and test scripts, troubleshoot setup, and organize
the report. The assistant also ran the documented commands in our local test
environment. Results were checked against actual database output, application
responses and test logs. Missing evidence and incomplete work are stated.

## Reuse

Do not run setup scripts against existing databases without reviewing them.
They do not delete databases or intentionally reset existing data. Use original
project repositories for application schema, seed and startup procedures. Runtime
credentials stay in local configuration. Exported PowerShell harnesses take
-CredentialFile pointing to a locally held Windows-DPAPI credential hashtable;
those files are deliberately not included.
