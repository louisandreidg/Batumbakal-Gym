$ErrorActionPreference='Stop'
$p='E:\DATABASE\PostgreSQL\18\bin\psql.exe';$s=Import-Clixml "$PSScriptRoot\unisync-secrets.clixml"
$r=[Collections.Generic.List[object]]::new()
function T($who,$sql,$expected='Allowed',$db='grp10_unisyncdb'){
 $u=@{app='unisync_app';dba='unisync_dba';auditor='unisync_auditor'}[$who]
 $env:PGPASSWORD=[Net.NetworkCredential]::new('',$s[$who]).Password
 $q=('\set VERBOSITY verbose','BEGIN;',$sql,'ROLLBACK;')-join [Environment]::NewLine
 if($sql -like 'CREATE DATABASE*'){$q=$sql}
 $out=$q|& $p -X -w -a -h localhost -U $u -d $db -v ON_ERROR_STOP=1 2>&1|Out-String
 $code=$LASTEXITCODE
 $actual=if($code -eq 0){'Allowed'}elseif($out -match '42501|permission denied|pg_hba.conf rejects connection'){'Denied'}elseif($out -match '23514'){'Constraint denied'}else{'Other error'}
 $r.Add([pscustomobject]@{account=$u;database=$db;sql=$sql;expected=$expected;actual=$actual;passed=($expected -eq $actual);output=$out})
}
foreach($table in 'account','organization','membership','event','venue','event_schedule','registration','notification'){T app "SELECT count(*) FROM public.$table;"}
T app "INSERT INTO public.organization(organization_name,university_name) VALUES('Activity4 SQL test','Test'); UPDATE public.organization SET description='Updated',status='deleted' WHERE organization_name='Activity4 SQL test'; SELECT status FROM public.organization WHERE organization_name='Activity4 SQL test';"
foreach($table in 'account','organization','membership','event','venue','event_schedule','registration','notification'){T app "DELETE FROM public.$table;" Denied}
T auditor 'SELECT account_id,account_name,email,avatar_url,account_status FROM public.account LIMIT 1;'
T auditor 'SELECT password_hash FROM public.account;' Denied
T auditor 'SELECT count(*) FROM public.event;'
foreach($q in @("INSERT INTO public.organization(organization_name,university_name) VALUES('Forbidden','Test');","UPDATE public.organization SET description='Forbidden';","DELETE FROM public.organization;")){T auditor $q Denied}
foreach($who in 'app','auditor'){
 T $who 'CREATE TABLE public.activity4_ddl_probe(id int);' Denied
 T $who 'CREATE ROLE unisync_denied_probe;' Denied
 T $who 'CREATE DATABASE unisync_denied_probe;' Denied
}
T dba 'CREATE TABLE public.activity4_ddl_probe(id int); ALTER TABLE public.activity4_ddl_probe ADD COLUMN note text; DROP TABLE public.activity4_ddl_probe;'
T dba "INSERT INTO public.organization(organization_name,university_name) VALUES('Activity4 DBA probe','Test'); UPDATE public.organization SET description='Updated' WHERE organization_name='Activity4 DBA probe'; DELETE FROM public.organization WHERE organization_name='Activity4 DBA probe';"
T dba 'CREATE ROLE unisync_denied_probe;' Denied
T dba 'CREATE DATABASE unisync_denied_probe;' Denied
T app "INSERT INTO public.event_schedule(event_id,venue_id,event_date,start_time,end_time) VALUES(1,1,CURRENT_DATE,'10:00','09:00');" 'Constraint denied'
foreach($who in 'app','dba','auditor'){foreach($db in 'dropboxed_db','ReserveIT','grp99_gymdb'){T $who 'SELECT current_user;' Denied $db}}
$r|ConvertTo-Json -Depth 4|Set-Content "$PSScriptRoot\..\outputs\Activity4-UniSync\permission-results.json"
$env:PGPASSWORD=[Net.NetworkCredential]::new('',$s.app).Password
& $p -X -w -h localhost -U unisync_app -d grp10_unisyncdb -c "SELECT tablename,tableowner FROM pg_tables WHERE schemaname='public'; SELECT r.rolname AS login,g.rolname AS group_role FROM pg_auth_members m JOIN pg_roles r ON r.oid=m.member JOIN pg_roles g ON g.oid=m.roleid WHERE r.rolname LIKE 'unisync%'; SELECT organization_name,university_name,status FROM public.organization WHERE organization_name LIKE 'Activity4 UniSync%';" > "$PSScriptRoot\..\outputs\Activity4-UniSync\database-inventory.txt"
Remove-Item Env:PGPASSWORD
$r|Group-Object passed|Select-Object Name,Count
$r|Where-Object {-not $_.passed}|Format-List

