# Query plan interpretation

The dashboard registration count joins event and organization and filters registrations. Refreshing registration/event/organization statistics improved row estimates. The count query still computes all matches even when the dashboard page is paginated; consider workload and existing account/status/event indexes only if it becomes costly. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Before
```text
Aggregate: estimated 1, actual 1.0, loops 1
  Nested Loop: estimated 1, actual 9.0, loops 1
    Hash Join: estimated 1, actual 50.0, loops 1
      Seq Scan on event: estimated 51, actual 51.0, loops 1
      Hash: estimated 1, actual 30.0, loops 1
        Seq Scan on organization: estimated 1, actual 30.0, loops 1
    Index Scan on registration: estimated 1, actual 0.18, loops 50
```

After authorized statistics maintenance
```text
Aggregate: estimated 1, actual 1.0, loops 1
  Hash Join: estimated 8, actual 9.0, loops 1
    Seq Scan on organization: estimated 30, actual 30.0, loops 1
    Hash: estimated 8, actual 9.0, loops 1
      Hash Join: estimated 8, actual 9.0, loops 1
        Seq Scan on event: estimated 51, actual 51.0, loops 1
        Hash: estimated 8, actual 9.0, loops 1
          Bitmap Heap Scan on registration: estimated 8, actual 9.0, loops 1
            Bitmap Index Scan: estimated 9, actual 9.0, loops 1
```

Execution times are single observations, influenced by cache and process scheduling. They do not prove a speedup or production performance.
