SELECT jsonb_build_object('rows',count(*),'marker',min(marker)) FROM activity6_probe.recovery_record WHERE probe_id=1 AND marker='COMP018-A6-G11-20261107';
