# Query plan interpretation

The occupancy query scans reservations and probes customer by index. This is reasonable for the small sample. If confirmed bookings become large, evaluate a selective status/time access path against real workload; a new index adds storage and booking-write cost. Maintenance is not currently authorized for this account. Ask the owner to grant table-scoped MAINTAIN to a dedicated NOLOGIN maintenance group and login; keep the application/reporting account unchanged.

Before
```text
Nested Loop: estimated 1, actual 1.0, loops 1
  Seq Scan on reservation: estimated 1, actual 1.0, loops 1
  Index Scan on customer: estimated 1, actual 1.0, loops 1
```

No post-maintenance plan: maintenance was withheld.

Execution times are single observations, influenced by cache and process scheduling. They do not prove a speedup or production performance.
