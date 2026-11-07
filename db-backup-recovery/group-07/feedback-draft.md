# Feedback draft not sent

Activity 6 backup and recovery worked for Applicant Management in our local environment. Backup and recovery worked after mapping owner-specific default privileges to the test owner. Please keep a documented backup account, protect the archives and test restores regularly. We propose a 24-hour RPO and 4-hour RTO for review. The initial backup cannot recover later writes; stricter loss targets need more frequent backups or WAL-based recovery.
