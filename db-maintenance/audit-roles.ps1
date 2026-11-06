$ErrorActionPreference='Stop'
$p='E:\DATABASE\PostgreSQL\18\bin\psql.exe';$root=$PSScriptRoot;$cfg=Get-Content "$PSScriptRoot\project-config.json" -Raw|ConvertFrom-Json;$records=@(Get-Content "$root\execution-records.json" -Raw|ConvertFrom-Json)
$env:PGCONNECT_TIMEOUT='5';$env:PGAPPNAME='COMP018_Activity5';$env:PGOPTIONS='-c statement_timeout=15000 -c lock_timeout=2000'
foreach($d in $cfg){
 if(-not $d.inspect_file){continue};$s=Import-Clixml "$PSScriptRoot\$($d.inspect_file)-secrets.clixml";$env:PGPASSWORD=[Net.NetworkCredential]::new('',$s[$d.inspect_key]).Password
 $names=@($d.roles|ForEach-Object {$_[0]})|Select-Object -Unique;$list=($names|ForEach-Object {"'$_'"})-join ','
 $sql=@"
SELECT jsonb_build_object('account',current_user,'roles',(SELECT jsonb_agg(to_jsonb(r)) FROM (SELECT rolname,rolcanlogin,rolsuper,rolcreatedb,rolcreaterole FROM pg_roles WHERE rolname IN($list) OR oid IN(SELECT roleid FROM pg_auth_members WHERE member IN(SELECT oid FROM pg_roles WHERE rolname IN($list))) ORDER BY rolname)r),'memberships',(SELECT jsonb_agg(to_jsonb(x)) FROM (SELECT r.rolname AS member,g.rolname AS group_role FROM pg_auth_members m JOIN pg_roles r ON r.oid=m.member JOIN pg_roles g ON g.oid=m.roleid WHERE r.rolname IN($list) ORDER BY 1,2)x));
"@
 $output=$sql|& $p -X -w -A -t -h localhost -U $d.inspector -d ($d.database -split ' / ')[0] -v ON_ERROR_STOP=1 2>&1|Out-String;$code=$LASTEXITCODE
 $records+=[pscustomobject]@{group=$d.group;label='role-audit';account=$d.inspector;database=($d.database -split ' / ')[0];timestamp=[DateTimeOffset]::Now.ToString('o');sql=$sql;output=$output;exit_code=$code}
 $sql|Set-Content "$root\group-$($d.group)\role-audit.sql" -Encoding utf8;$output|Set-Content "$root\group-$($d.group)\role-audit.txt" -Encoding utf8
 if($code){throw 'Role audit failed'}
 $j=$output|ConvertFrom-Json;foreach($name in $names){if($name -notin $j.roles.rolname){throw "Missing planned role $name"}}
}
$records|ConvertTo-Json -Depth 6|Set-Content "$root\execution-records.json" -Encoding utf8;Remove-Item Env:PGPASSWORD -ErrorAction SilentlyContinue;'All planned accounts/groups in reachable projects are present.'
