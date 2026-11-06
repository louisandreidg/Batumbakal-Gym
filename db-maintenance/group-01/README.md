# Activity 5 G01 DropBoxed

Inspection date: 7 November 2026

Repository: https://github.com/joshxaaaaaa/GRP1_Dropboxed

Snapshot: Earlier local ZIP; revision not established

Database/schema: dropboxed_db / dropboxed

Health: Not reachable

Priority: Immediate action

## Accounts and role confirmation

Inspection: dropboxed_app. Query: dropboxed_app. Maintenance candidate: dropboxed_app. Roles are the existing Activity 4 accounts; no new privilege was granted.

Not verified this activity; prior metadata audit only.

## Health and activity

The client returned fe_sendauth: no password supplied. This is an authentication-configuration blocker, not evidence that PostgreSQL is down.

## Logs and issue assessment

Current connection.txt reports a missing client password. Shared historical errors are not reliably attributable to this project unless the line identifies the account or database. The database was not inspected through an administrator workaround.

## Maintenance purpose and outcome

Not run - intended-account authentication unavailable

No maintenance was attempted without authenticated access.

## Query and recommendation

No query analyzed.

Securely configure the original Activity 4 application-account password and finish the unresolved access-control plan; then rerun monitoring. Do not reset another project or use postgres to bypass the account.

## Limits

Health, session and statistics values are a point-in-time local test sample. Other users query details may be hidden by PostgreSQL. SQL permissions were not bypassed. The data set is small and no load benchmark or production certification is implied. Earlier Activity 4 functional issues are separate from current database monitoring.

## Feedback

No - drafted for owner review; not sent
