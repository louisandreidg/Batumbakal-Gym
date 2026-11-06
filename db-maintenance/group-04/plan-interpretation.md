# Query plan interpretation

Initial join estimates were much larger than the tiny actual tables. ANALYZE on appointments and its patient/doctor/specialty inputs corrected these estimates. Sequential scans and small in-memory joins are reasonable here. For a larger filtered appointment workload, inspect date predicates and existing indexes before adding a date index. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Before
```text
Sort: estimated 510, actual 2.0, loops 1
  Hash Join: estimated 510, actual 2.0, loops 1
    Hash Join: estimated 510, actual 2.0, loops 1
      Hash Join: estimated 510, actual 2.0, loops 1
        Seq Scan on appointments: estimated 510, actual 2.0, loops 1
        Hash: estimated 70, actual 2.0, loops 1
          Seq Scan on patients: estimated 70, actual 2.0, loops 1
      Hash: estimated 140, actual 3.0, loops 1
        Seq Scan on doctors: estimated 140, actual 3.0, loops 1
    Hash: estimated 320, actual 4.0, loops 1
      Seq Scan on specialties: estimated 320, actual 4.0, loops 1
```

After authorized statistics maintenance
```text
Sort: estimated 2, actual 2.0, loops 1
  Nested Loop: estimated 2, actual 2.0, loops 1
    Hash Join: estimated 3, actual 3.0, loops 1
      Seq Scan on specialties: estimated 4, actual 4.0, loops 1
      Hash: estimated 3, actual 3.0, loops 1
        Seq Scan on doctors: estimated 3, actual 3.0, loops 1
    Materialize: estimated 2, actual 2.0, loops 3
      Nested Loop: estimated 2, actual 2.0, loops 1
        Seq Scan on appointments: estimated 2, actual 2.0, loops 1
        Materialize: estimated 2, actual 1.5, loops 2
          Seq Scan on patients: estimated 2, actual 2.0, loops 1
```

Execution times are single observations, influenced by cache and process scheduling. They do not prove a speedup or production performance.
