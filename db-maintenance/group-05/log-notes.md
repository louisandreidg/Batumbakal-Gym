# Log review

The restricted inspection account cannot examine log_directory (pg_read_all_settings required). This expected Activity 5 inspection denial is evidenced in log-settings.txt; it is not an application failure. The authorized Windows account separately reviewed available shared severity logs without changing logging settings. log_line_prefix contains only time, so most historical lines cannot be assigned to this database reliably. See ../shared-log-review.json. No ongoing blocking was seen at the sampled instant; that does not exclude past or future waits.

Impact: limited attribution can slow incident diagnosis. Recommendation: the server owner can consider a prefix containing time, database, user and PID after reviewing privacy; this activity did not change configuration or grant pg_read_all_stats/settings. Historical deliberate denial/constraint probes must not be treated as new outages.
