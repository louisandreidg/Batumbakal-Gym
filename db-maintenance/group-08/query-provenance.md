# Selected application query

Repository: https://github.com/yami-sumi/catering-management-system

Snapshot: main / a415ead922213f9b559339ab26e17f30924fb1a1

Source: backend/routes/customerPortal.js:83; customer package catalog

Account: catering_app (Activity 4 shared application runtime). SQL parameters are fixed local examples; no personal result rows are exported. G02 uses a documented SQL translation of the JPQL predicate.

```sql
SELECT package_id,package_name,description,price_per_guest FROM public.package ORDER BY package_id;
```

EXPLAIN was captured first. EXPLAIN ANALYZE executed only this safe SELECT; no application write, volatile user function, FOR UPDATE or external service is invoked. JSON output includes plans and timings rather than result-row contents.
