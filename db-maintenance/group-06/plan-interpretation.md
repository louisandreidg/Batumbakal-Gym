# Query plan interpretation

The vehicle catalog uses joins, a sort and a per-vehicle correlated rate lookup. Related-table ANALYZE improved estimates. At larger vehicle volume, compare a preselected daily-rate join with the repeated lookup, and inspect existing rental-rate indexes first. Do not add a duplicate index on this small sample. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Before
```text
Sort: estimated 1, actual 8.0, loops 1
  Hash Join: estimated 1, actual 8.0, loops 1
    Seq Scan on vehicle: estimated 89, actual 8.0, loops 1
    Hash: estimated 1, actual 4.0, loops 1
      Seq Scan on vehicle_category: estimated 1, actual 4.0, loops 1
    Limit: estimated 1, actual 1.0, loops 8
      Sort: estimated 1, actual 1.0, loops 8
        Seq Scan on rental_rate: estimated 1, actual 1.0, loops 8
```

After authorized statistics maintenance
```text
Sort: estimated 8, actual 8.0, loops 1
  Hash Join: estimated 8, actual 8.0, loops 1
    Seq Scan on vehicle: estimated 8, actual 8.0, loops 1
    Hash: estimated 4, actual 4.0, loops 1
      Seq Scan on vehicle_category: estimated 4, actual 4.0, loops 1
    Limit: estimated 1, actual 1.0, loops 8
      Sort: estimated 1, actual 1.0, loops 8
        Seq Scan on rental_rate: estimated 1, actual 1.0, loops 8
```

Execution times are single observations, influenced by cache and process scheduling. They do not prove a speedup or production performance.
