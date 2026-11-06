# Selected application query

Repository: https://github.com/123airabels/Car_Rental_Management_System

Snapshot: main / ea2cd1691a08cb0e455fc18b398a7570cac1b7ad

Source: Application/src/main/java/com/carrental/car_rental_app/web/VehicleController.java:27; list without optional filters

Account: app_runtime (Activity 4 shared application runtime). SQL parameters are fixed local examples; no personal result rows are exported. G02 uses a documented SQL translation of the JPQL predicate.

```sql
SELECT v.vehicle_id,v.make,v.model,v.year,c.category_name,v.seating_capacity,v.fuel_type,v.color,v.status,(SELECT r.rate_amount FROM public.rental_rate r WHERE r.category_id=v.category_id AND r.rental_period_type='Daily' AND r.rate_status='Active' ORDER BY r.rate_id LIMIT 1)+v.unit_rate_adjustment AS daily_rate FROM public.vehicle v JOIN public.vehicle_category c ON c.category_id=v.category_id WHERE c.category_status='Active' AND v.status<>'Retired' ORDER BY c.category_name,v.make,v.model;
```

EXPLAIN was captured first. EXPLAIN ANALYZE executed only this safe SELECT; no application write, volatile user function, FOR UPDATE or external service is invoked. JSON output includes plans and timings rather than result-row contents.
