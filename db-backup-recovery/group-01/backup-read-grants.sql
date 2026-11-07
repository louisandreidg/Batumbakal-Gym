GRANT CONNECT ON DATABASE "dropboxed_db" TO a6_g01_backup_grp;
GRANT USAGE ON SCHEMA "dropboxed" TO a6_g01_backup_grp;
GRANT SELECT ON ALL TABLES IN SCHEMA "dropboxed" TO a6_g01_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "dropboxed" TO a6_g01_backup_grp;
GRANT USAGE ON SCHEMA "public" TO a6_g01_backup_grp;
GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO a6_g01_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "public" TO a6_g01_backup_grp;
