# Activity 6 Backup and Recovery

[Progress report](../docs/Activity6-Progress-Report.pdf)

Each group folder contains the backup plan, commands, archive metadata, restore checks and recovery results. Data archives and credentials are stored privately outside the repository.

All projects were backed up and recovered in separate test databases. G01/G03 retain their earlier runtime-role design gaps. G04/G06/G07 required default privileges to be mapped to the test owner. Original application data and passwords were preserved.

backup-metadata.json records the archive file names, sizes and SHA-256 checksums. execution-index.json points to command output. latest-results.json contains each final result; earlier errors remain in the case logs. Role memberships, object grants, data fingerprints and sequence states were checked.

Recovery deleted only one labeled row in a disposable probe table, after verifying a checkpoint restore. No application rows were deleted. The initial source archive predates that probe; recovery used the later checkpoint.

See REPRODUCE.md before running the scripts. Existing roles must not be overwritten, and backup storage must stay outside the repository. Feedback files are drafts and have not been sent.
