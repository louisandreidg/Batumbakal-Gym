$ErrorActionPreference='Stop'
$p='E:\DATABASE\PostgreSQL\18\bin\psql.exe'
$outRoot=$PSScriptRoot
New-Item -ItemType Directory $outRoot -Force|Out-Null
$env:PGCONNECT_TIMEOUT='5';$env:PGAPPNAME='COMP018_Activity5';$env:PGOPTIONS='-c statement_timeout=15000 -c lock_timeout=2000';$env:PGPASSFILE=Join-Path $PSScriptRoot 'no-activity5-password-file'
$secrets=@{}
foreach($name in 'group02','group07','reserveit','batch4','unisync'){$secrets[$name]=Import-Clixml (Join-Path $PSScriptRoot ($name+'-secrets.clixml'))}
$records=[Collections.Generic.List[object]]::new()
function Run($d,$label,$user,$secretFile,$key,$sql){
 Remove-Item Env:PGPASSWORD -ErrorAction SilentlyContinue
 if($secretFile){$env:PGPASSWORD=[Net.NetworkCredential]::new('',$secrets[$secretFile][$key]).Password}
 $path=Join-Path $outRoot ('group-'+$d.group)
 $sql|Set-Content (Join-Path $path ($label+'.sql')) -Encoding utf8
 $stamp=[DateTimeOffset]::Now.ToString('o')
 $output=$sql|& $p -X -w -A -t -h localhost -U $user -d (($d.database -split ' / ')[0]) -v ON_ERROR_STOP=1 2>&1|Out-String
 $exit=$LASTEXITCODE
 $r=[pscustomobject]@{group=$d.group;label=$label;database=($d.database -split ' / ')[0];account=$user;timestamp=$stamp;exit_code=$exit;sql=$sql;output=$output}
 $records.Add($r);$output|Set-Content (Join-Path $path ($label+'.txt')) -Encoding utf8
 return $r
}
foreach($d in (Get-Content (Join-Path $PSScriptRoot 'project-config.json') -Raw|ConvertFrom-Json)){
 New-Item -ItemType Directory (Join-Path $outRoot ('group-'+$d.group)) -Force|Out-Null
 $connect=Run $d connection $d.inspector $d.inspect_file $d.inspect_key 'SELECT current_database(),current_user,version();'
 if($connect.exit_code){Write-Output ('G'+$d.group+': intended account unavailable; recorded, continuing.');continue}
 $names=@($d.inspector,$d.query_account,$d.maintenance_account)|Select-Object -Unique
 $list=($names|ForEach-Object {"'$_'"}) -join ','
 $target=$d.target
 $health=@"
SELECT jsonb_build_object(
'environment',jsonb_build_object('database',current_database(),'account',current_user,'version',version(),'server_start',pg_postmaster_start_time(),'database_bytes',pg_database_size(current_database()),'size',pg_size_pretty(pg_database_size(current_database())),'autovacuum',current_setting('autovacuum')),
'database_stats',(SELECT to_jsonb(s) FROM pg_stat_database s WHERE datname=current_database()),
'objects',(SELECT jsonb_build_object('tables',count(*) FILTER(WHERE relkind IN('r','p')),'indexes',count(*) FILTER(WHERE relkind='i'),'views',count(*) FILTER(WHERE relkind='v'),'sequences',count(*) FILTER(WHERE relkind='S')) FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname NOT IN('pg_catalog','information_schema') AND n.nspname NOT LIKE 'pg_toast%'),
'tables',(SELECT COALESCE(jsonb_agg(to_jsonb(t)),'[]') FROM (SELECT s.schemaname,s.relname,s.n_live_tup,s.n_dead_tup,s.n_mod_since_analyze,s.last_analyze,s.last_autoanalyze,s.last_vacuum,s.last_autovacuum,pg_total_relation_size(s.relid) AS total_bytes,pg_get_userbyid(c.relowner) AS owner,c.reloptions FROM pg_stat_user_tables s JOIN pg_class c ON c.oid=s.relid ORDER BY 1,2)t),
'indexes',(SELECT COALESCE(jsonb_agg(to_jsonb(i)),'[]') FROM (SELECT schemaname,tablename,indexname,indexdef FROM pg_indexes WHERE schemaname NOT IN('pg_catalog','information_schema') ORDER BY 1,2,3)i),
'sessions',(SELECT COALESCE(jsonb_agg(to_jsonb(a)),'[]') FROM (SELECT pid,usename,state,wait_event_type,wait_event,query_start,round(extract(epoch FROM clock_timestamp()-query_start)::numeric,3) AS duration_seconds,cardinality(pg_blocking_pids(pid)) AS blockers,CASE WHEN query ~* 'password|token|secret|cookie|authorization|credential' THEN '[sensitive query text withheld]' ELSE left(query,500) END AS query,pid=pg_backend_pid() AS collecting_session FROM pg_stat_activity WHERE datname=current_database() ORDER BY query_start NULLS LAST)a),
'roles',(SELECT COALESCE(jsonb_agg(to_jsonb(r)),'[]') FROM (SELECT rolname,rolcanlogin,rolsuper,rolcreatedb,rolcreaterole FROM pg_roles WHERE rolname IN ($list) OR oid IN(SELECT roleid FROM pg_auth_members WHERE member IN(SELECT oid FROM pg_roles WHERE rolname IN($list))) ORDER BY rolname)r),
'memberships',(SELECT COALESCE(jsonb_agg(to_jsonb(m)),'[]') FROM (SELECT r.rolname AS member,g.rolname AS group_role FROM pg_auth_members a JOIN pg_roles r ON r.oid=a.member JOIN pg_roles g ON g.oid=a.roleid WHERE r.rolname IN($list) ORDER BY 1,2)m),
'privilege_sample',(SELECT jsonb_agg(to_jsonb(v)) FROM (SELECT rolname,has_table_privilege(rolname,'$target','SELECT') AS can_select,has_table_privilege(rolname,'$target','INSERT') AS can_insert,has_table_privilege(rolname,'$target','UPDATE') AS can_update,has_table_privilege(rolname,'$target','DELETE') AS can_delete,has_table_privilege(rolname,'$target','MAINTAIN') AS can_maintain FROM pg_roles WHERE rolname IN($list))v),
'xid_age',(SELECT age(datfrozenxid) FROM pg_database WHERE datname=current_database())
);
"@
 $h=Run $d health-before $d.inspector $d.inspect_file $d.inspect_key $health
 if($h.exit_code){Write-Output ('G'+$d.group+': health query failed; evidence retained.');continue}
 Run $d log-settings $d.inspector $d.inspect_file $d.inspect_key "SELECT jsonb_build_object('log_destination',current_setting('log_destination'),'logging_collector',current_setting('logging_collector'),'log_directory',current_setting('log_directory'),'log_filename',current_setting('log_filename'),'log_line_prefix',current_setting('log_line_prefix'),'log_min_duration_statement',current_setting('log_min_duration_statement'),'log_lock_waits',current_setting('log_lock_waits'));"|Out-Null
 Run $d explain $d.query_account $d.query_file $d.query_key ('EXPLAIN (FORMAT JSON) '+$d.query)|Out-Null
 Run $d plan-before $d.query_account $d.query_file $d.query_key ('EXPLAIN (ANALYZE,BUFFERS,FORMAT JSON) '+$d.query)|Out-Null
 $permission=Run $d maintenance-permission $d.maintenance_account $d.maintenance_file $d.maintenance_key "SELECT jsonb_build_object('account',current_user,'target','$target','database_owner',current_user=pg_get_userbyid(datdba),'maintain',has_table_privilege('$target','MAINTAIN'),'pg_maintain',pg_has_role(current_user,'pg_maintain','USAGE')) FROM pg_database WHERE datname=current_database();"
 $allowed=$false
 if($permission.exit_code -eq 0){$j=$permission.output|ConvertFrom-Json;$allowed=($j.database_owner -or $j.maintain -or $j.pg_maintain)}
 $comment=@"
-- Selected target: $target. Review health-before.txt and maintenance-permission.txt first.
-- ANALYZE refreshes planner statistics after Activity 4 test writes.
-- Ordinary VACUUM makes dead-row space reusable and updates visibility information.
-- This is a small local test table. No VACUUM FULL, data reset or index creation.
-- Run each statement standalone as $($d.maintenance_account); use a 2-second lock timeout.
-- If that account lacks ownership/MAINTAIN/database-owner permission, do not run;
-- record the limitation and request a table-scoped maintenance role from its owner.
ANALYZE VERBOSE $target;
VACUUM (VERBOSE,ANALYZE) $target;
"@
 $comment|Set-Content (Join-Path $outRoot ('group-'+$d.group+'\maintenance.sql')) -Encoding utf8
 if($allowed){
  Run $d analyze $d.maintenance_account $d.maintenance_file $d.maintenance_key "ANALYZE VERBOSE $target;"|Out-Null
  Run $d vacuum $d.maintenance_account $d.maintenance_file $d.maintenance_key "VACUUM (VERBOSE,ANALYZE) $target;"|Out-Null
  Run $d health-after $d.inspector $d.inspect_file $d.inspect_key $health|Out-Null
  Run $d plan-after $d.query_account $d.query_file $d.query_key ('EXPLAIN (ANALYZE,BUFFERS,FORMAT JSON) '+$d.query)|Out-Null
  Write-Output ('G'+$d.group+': inspection, safe SELECT plan and authorized maintenance recorded.')
 }else{Write-Output ('G'+$d.group+': inspection/plan recorded; maintenance withheld for lack of privilege.')}
}
$records|ConvertTo-Json -Depth 6|Set-Content (Join-Path $outRoot 'execution-records.json') -Encoding utf8
Remove-Item Env:PGPASSWORD -ErrorAction SilentlyContinue
