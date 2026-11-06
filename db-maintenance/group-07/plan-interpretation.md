# Query plan interpretation

The department list joins positions, counts them, sorts names and paginates. Statistics on department and position now reflect the sample better. Existing indexes are adequate here. Leading-wildcard ILIKE searches need separate workload measurement; an ordinary B-tree should not be assumed to fix them. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Before
```text
Limit: estimated 10, actual 5.0, loops 1
  Aggregate: estimated 280, actual 5.0, loops 1
    Nested Loop: estimated 280, actual 8.0, loops 1
      Index Scan on department: estimated 280, actual 5.0, loops 1
      Index Scan on position: estimated 1, actual 1.6, loops 5
```

After authorized statistics maintenance
```text
Limit: estimated 5, actual 5.0, loops 1
  Sort: estimated 5, actual 5.0, loops 1
    Aggregate: estimated 5, actual 5.0, loops 1
      Hash Join: estimated 8, actual 8.0, loops 1
        Seq Scan on position: estimated 8, actual 8.0, loops 1
        Hash: estimated 5, actual 5.0, loops 1
          Seq Scan on department: estimated 5, actual 5.0, loops 1
```

Execution times are single observations, influenced by cache and process scheduling. They do not prove a speedup or production performance.
