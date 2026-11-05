-- Apply after the group's unmodified Flyway V1-V3. Only Group 2 objects affected.
BEGIN;
GRANT USAGE ON SCHEMA school_event_management_db TO grp02_runtime_grp,grp02_readonly_grp;
GRANT SELECT ON school_event_management_db.role TO grp02_runtime_grp;
GRANT SELECT,INSERT,UPDATE ON school_event_management_db.user_account TO grp02_runtime_grp;
GRANT SELECT,INSERT,UPDATE,DELETE ON school_event_management_db.venue,school_event_management_db.participant,school_event_management_db.event,school_event_management_db.event_schedule,school_event_management_db.event_assignment,school_event_management_db.attendance TO grp02_runtime_grp;
GRANT SELECT,INSERT ON school_event_management_db.audit_log TO grp02_runtime_grp;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA school_event_management_db TO grp02_runtime_grp;
GRANT SELECT ON school_event_management_db.role,school_event_management_db.venue,school_event_management_db.event TO grp02_readonly_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA school_event_management_db FROM event_app;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA school_event_management_db FROM event_app;
REVOKE ALL ON SCHEMA school_event_management_db FROM event_app;
COMMIT;
-- Future objects receive no automatic runtime grants. New migrations must assign
-- reviewed privileges explicitly to these group roles. Do not grant ALL by default.
