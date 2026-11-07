# Feedback draft not sent

Activity 6 backup and recovery worked for PAWPAW Veterinary in our local environment. Backup and recovery worked; the existing direct-grant runtime design still needs review. Please keep a documented backup account, protect the archives and test restores regularly. We propose a 1-hour RPO and 1-hour RTO for review. The initial backup cannot recover later writes; stricter loss targets need more frequent backups or WAL-based recovery.
