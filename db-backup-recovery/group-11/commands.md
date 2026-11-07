# Commands used

```text
pg_dump -w -h localhost -U a6_g11_backup -Fc --verbose -d ReserveIT > g11_source_run1.dump
pg_restore --list g11_source_run1.dump
pg_restore -w -h localhost -U a6_g11_restore --verbose --exit-on-error --single-transaction --no-owner -d a6_g11_restore_20261107 g11_source_run1.dump
```

Binary stdout from pg_dump was saved without text conversion. The archive directory is private; command paths above use the file names for portability. Each restore target was checked to be an empty designated test database. --no-owner maps ownership only; normal object privileges were restored. DEFAULT ACL entries, where present, were explicitly replayed for the isolated owner.
