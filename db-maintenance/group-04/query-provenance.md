# Selected application query

Repository: https://github.com/RainneQuintab/GRP03_PROJECTDB

Snapshot: main / 2e5abb5440c1e2f7cadc364352a598ca220c7bc7

Source: backend/staff_appointments.php:39; unfiltered appointment listing

Account: hb_app (Activity 4 shared application runtime). SQL parameters are fixed local examples; no personal result rows are exported. G02 uses a documented SQL translation of the JPQL predicate.

```sql
SELECT a.appointment_id,a.appointment_date,a.status,a.reason,p.patient_id,p.first_name AS patient_first,p.last_name AS patient_last,p.contact_number,d.doctor_id,d.first_name AS doctor_first,d.last_name AS doctor_last,sp.specialty_name FROM public.appointments a JOIN public.patients p ON p.patient_id=a.patient_id JOIN public.doctors d ON d.doctor_id=a.doctor_id LEFT JOIN public.specialties sp ON sp.specialty_id=d.specialty_id ORDER BY a.appointment_date;
```

EXPLAIN was captured first. EXPLAIN ANALYZE executed only this safe SELECT; no application write, volatile user function, FOR UPDATE or external service is invoked. JSON output includes plans and timings rather than result-row contents.
