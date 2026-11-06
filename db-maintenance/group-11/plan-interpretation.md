# Query plan interpretation

The dashboard groups all reservations by status. A sequential scan with aggregation is reasonable because every row contributes. ANALYZE corrected the estimate for this small table. An extra status index is not justified merely by the scan; consider summaries only after measuring realistic volumes. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Before
```text
Aggregate: estimated 120, actual 5.0, loops 1
  Seq Scan on reservation: estimated 120, actual 8.0, loops 1
```

After authorized statistics maintenance
```text
Aggregate: estimated 5, actual 5.0, loops 1
  Seq Scan on reservation: estimated 8, actual 8.0, loops 1
```

Execution times are single observations, influenced by cache and process scheduling. They do not prove a speedup or production performance.
