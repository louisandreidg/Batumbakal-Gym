# Selected application query

Repository: https://github.com/CoffyJosh/unisync

Snapshot: main / c3b916a080f3201567f467a456d55c74b9ca3ba8

Source: php/app/dashboard/get_dashboard.php:31; account 1 and empty search

Account: unisync_app (Activity 4 shared application runtime). SQL parameters are fixed local examples; no personal result rows are exported. G02 uses a documented SQL translation of the JPQL predicate.

```sql
SELECT COUNT(*) FROM public.registration r INNER JOIN public.event e ON r.event_id=e.event_id INNER JOIN public.organization o ON e.organization_id=o.organization_id WHERE r.account_id=1 AND r.status='active' AND e.status<>'deleted' AND o.status='active' AND o.organization_name ILIKE '%%';
```

EXPLAIN was captured first. EXPLAIN ANALYZE executed only this safe SELECT; no application write, volatile user function, FOR UPDATE or external service is invoked. JSON output includes plans and timings rather than result-row contents.
