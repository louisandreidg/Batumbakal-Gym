# Activity 6 Backup Restoration and Recovery

[Progress PDF](Activity6-Progress-Report.pdf)

Group 9 Batumbakal Gym. Louis Andrei de Guzman and Mark Timothy Casilan. Test date 7 November 2026.

Each group-XX folder contains its backup plan, command list, archive metadata, restore output, verification SQL, role plan, recovery evidence and findings. Archives contain application data and are stored in a protected local directory outside this repository. No archive, credential file, Word report or tracker preparation file is uploaded.

All projects were backed up and recovered. G01/G03 retain their earlier runtime-role design gaps. G04/G06/G07 needed owner-specific default privileges explicitly mapped to the isolated restore owner. Existing application data and passwords were preserved. Only one labeled probe in each disposable incident database was deleted, after verifying a checkpoint restore. Backup/recovery timing covers the database test, not a full application restart.

execution-index.json identifies accounts, commands, times and case files. backup-metadata.json records archive names, sizes and SHA-256 hashes. Earlier errors remain in their original case logs; the final successful run is identified per project. Equivalent literal text-array cast forms are normalized for comparison; original expressions remain available. Default grants and role memberships were also checked separately.

Roles are cluster-wide. The fresh-cluster reconstruction scripts contain no passwords and must be reviewed before use; do not overwrite existing roles. --no-owner intentionally maps object ownership to the isolated test owner. Ordinary ACLs are restored; reviewed DEFAULT ACL entries are replayed for that owner instead of granting superuser access. New account-specific localhost rules restrict backup and clone accounts without changing existing account rules.

Feedback messages remain drafts and the live tracker was not edited. Submit the PDF and repository link after entering the Activity 6 Log and reviewing feedback.

Repository: https://github.com/louisandreidg/Batumbakal-Gym
Tracker: https://docs.google.com/spreadsheets/d/1BClCa9rEs9o-D9Rp3tUZVhECipJ234zX/edit?gid=2123136180
