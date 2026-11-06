# Selected application query

Repository: https://github.com/JosephEmmanuelBabas/School_Event_Management_Web_Appli

Snapshot: main ZIP; commit unavailable; SHA256 B251FC9C32CECF3090C7AC0ED14EF11862BE29E89656947DBF3A6F00B86569B3

Source: school_event_management/src/main/java/com/school_event/school_event_management/repository/EventRepository.java:19; JPQL countVenueConflicts translated to SQL; venue 1, today, 08:00-17:00, exclusion 0

Account: event_app (Activity 4 shared application runtime). SQL parameters are fixed local examples; no personal result rows are exported. G02 uses a documented SQL translation of the JPQL predicate.

```sql
SELECT count(*) FROM school_event_management_db.event e WHERE e.venue_id=1 AND e.event_date=CURRENT_DATE AND e.event_status<>'Cancelled' AND e.start_time<TIME '17:00' AND e.end_time>TIME '08:00' AND e.event_id<>0;
```

EXPLAIN was captured first. EXPLAIN ANALYZE executed only this safe SELECT; no application write, volatile user function, FOR UPDATE or external service is invoked. JSON output includes plans and timings rather than result-row contents.
