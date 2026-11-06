# Activity 4 - consolidated submission

Group 09 Batumbakal Gym. Members: Louis Andrei de Guzman; Mark Timothy Casilan. Updated 6 November 2026.

Latest report: [Activity4-Progress-Report.pdf](Activity4-Progress-Report.pdf). Editable text: [Activity4-Progress-Report.md](Activity4-Progress-Report.md).

This package covers all other roster projects. G04 is HealthBridge, G05 is SHIORI and G10 is UniSync; database/repository names can differ from group numbers. Earlier sibling reports are historical and superseded by this consolidated report.

G01/G03 are included with explicit limitations: current metadata was audited, but original restricted-login operation logs were not recovered and their least-privilege group/isolation work remains incomplete. Their existing databases/grants were preserved as requested. Do not claim every Activity 4 requirement is finished.

## Files

- group-XX/: setup guidance, role plans, original evidence and labeled reconstructed SQL.
- verification-results.csv: full allowed/denied SQL matrix with account, exact SQL, expected/actual results and evidence references.
- feedback-sent.md/json: actual delivered GitHub issue links and dates.
- Activity4-Log-paste-ready.tsv: official eight-column log; paste into a new Activity 4 Log tab at A1. Review before submission. The original class tracker was not changed.
- SHA256SUMS.txt: final package integrity manifest.

## Security and reproducibility

Original application source and pre-existing data were preserved. New testing databases used separate restricted logins; schema owners provisioned objects. No superuser application login was used for the newly provisioned projects. Original G01/G03 application-account authentication was not reverified.

Run schema/seed from each recorded source snapshot before reconstructed grants. These scripts are not execution transcripts or unattended deployment installers. Supply passwords privately. Table ownership, future grants and function policies require the original scripts/plan. Role names are cluster-wide: project-specific role mappings avoid collisions. Do not reset an existing database or execute UniSync's reset script on existing data.

Working account isolation depends on matching project-specific pg_hba rules. Existing unrelated PUBLIC CONNECT grants were not revoked. A function reporting CONNECT does not prove the account can authenticate; actual connections were tested for the newly provisioned accounts. G01/G03 isolation remains unverified.

Permission-only WHERE false cases, catalog audits and real affected-row SQL are distinguished. Failed SHIORI/UniSync application expectations remain failures even when SQL permission tests pass. External services, real payments, browser usability, performance and deployment security were not tested.

## Submission steps still requiring action

Paste/review the provided log in the instructor tracker and submit the required repository/report links through the class process. Browser automation could not safely identify the current URL and was stopped. G01/G03 still require the explicitly listed local testing work; no claim of complete verification is made for them.
