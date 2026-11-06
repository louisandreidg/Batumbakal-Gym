# Query plan interpretation

The event conflict query uses an existing index. The local event table is empty after previous test cleanup, so its plan cannot establish behavior at realistic event volume. Keep the existing overlap constraint/index; benchmark realistic dates and venues before considering another index. Review remaining tables after bulk test writes; only the selected table and explicitly listed related inputs were maintained.

Before
```text
Aggregate: estimated 1, actual 1.0, loops 1
  Index Scan on event: estimated 1, actual 0.0, loops 1
```

After authorized statistics maintenance
```text
Aggregate: estimated 1, actual 1.0, loops 1
  Seq Scan on event: estimated 1, actual 0.0, loops 1
```

Execution times are single observations, influenced by cache and process scheduling. They do not prove a speedup or production performance.
