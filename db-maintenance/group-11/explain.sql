EXPLAIN (FORMAT JSON) SELECT status,COUNT(*) AS n FROM public.reservation GROUP BY status;
