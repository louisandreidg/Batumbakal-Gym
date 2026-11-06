# Selected application query

Repository: https://github.com/LeeJnsn27/SHIORIcafe-new

Snapshot: main / 8fab8f7139e3f1d4565e5a600b3f3e5cf1f6cad8

Source: backend/api/get-table-occupancy.php:16; active table occupancy

Account: shiori_app (Activity 4 shared application runtime). SQL parameters are fixed local examples; no personal result rows are exported. G02 uses a documented SQL translation of the JPQL predicate.

```sql
SELECT r.table_id,r.reservation_start_at,r.reservation_end_at,c.full_name AS guest_name FROM shioricafe_schema.reservation r LEFT JOIN shioricafe_schema.customer c ON r.customer_id=c.customer_id WHERE r.status='Confirmed' AND CURRENT_TIMESTAMP>=r.reservation_start_at AND CURRENT_TIMESTAMP<r.reservation_end_at;
```

EXPLAIN was captured first. EXPLAIN ANALYZE executed only this safe SELECT; no application write, volatile user function, FOR UPDATE or external service is invoked. JSON output includes plans and timings rather than result-row contents.
