# Selected application query

Repository: https://github.com/mang2mas/grp07-applicant-management-system

Snapshot: main / 2ccec581b94708d5a8f864c353281454dc725fcd

Source: src/views/departments/index.php:20; first page without search

Account: grp07_app (Activity 4 shared application runtime). SQL parameters are fixed local examples; no personal result rows are exported. G02 uses a documented SQL translation of the JPQL predicate.

```sql
SELECT d.department_id,d.department_name,d.description,COUNT(p.position_id) AS position_count FROM public.department d LEFT JOIN public.position p ON p.department_id=d.department_id GROUP BY d.department_id,d.department_name,d.description ORDER BY d.department_name LIMIT 10 OFFSET 0;
```

EXPLAIN was captured first. EXPLAIN ANALYZE executed only this safe SELECT; no application write, volatile user function, FOR UPDATE or external service is invoked. JSON output includes plans and timings rather than result-row contents.
