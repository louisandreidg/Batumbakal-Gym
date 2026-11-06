$ErrorActionPreference='Stop'
$p='E:\DATABASE\PostgreSQL\18\bin\psql.exe';$root=$PSScriptRoot
$cfg=Get-Content "$PSScriptRoot\project-config.json" -Raw|ConvertFrom-Json
$records=Get-Content "$root\execution-records.json" -Raw|ConvertFrom-Json
$extra=[Collections.Generic.List[object]]::new()
$map=@{'04'=@('public.patients','public.doctors','public.specialties');'06'=@('public.vehicle_category','public.rental_rate');'07'=@('public.position');'10'=@('public.event','public.organization')}
$env:PGCONNECT_TIMEOUT='5';$env:PGOPTIONS='-c statement_timeout=15000 -c lock_timeout=2000';$env:PGAPPNAME='COMP018_Activity5'
foreach($g in $map.Keys){
 $d=$cfg|Where-Object group -eq $g;$s=Import-Clixml "$PSScriptRoot\$($d.maintenance_file)-secrets.clixml";$env:PGPASSWORD=[Net.NetworkCredential]::new('',$s[$d.maintenance_key]).Password
 $sql=foreach($t in $map[$g]){"SELECT has_table_privilege('$t','MAINTAIN') AS allowed;"}
 $check=$sql|& $p -X -w -A -t -h localhost -U $d.maintenance_account -d ($d.database -split ' / ')[0] -v ON_ERROR_STOP=1 2>&1|Out-String
 if($LASTEXITCODE -or ($check.Trim() -split '\s+'|Where-Object {$_ -ne 't'})){throw "Related-table MAINTAIN not verified for $g"}
 $sql=@(foreach($t in $map[$g]){"ANALYZE VERBOSE $t;"}) -join "`n"
 $output=$sql|& $p -X -w -A -t -h localhost -U $d.maintenance_account -d ($d.database -split ' / ')[0] -v ON_ERROR_STOP=1 2>&1|Out-String
 $extra.Add([pscustomobject]@{group=$g;label='analyze-related';account=$d.maintenance_account;timestamp=[DateTimeOffset]::Now.ToString('o');database=($d.database -split ' / ')[0];exit_code=$LASTEXITCODE;sql=$sql;output=$output})
 $sql|Set-Content "$root\group-$g\analyze-related.sql" -Encoding utf8;$output|Set-Content "$root\group-$g\analyze-related.txt" -Encoding utf8
 $s=Import-Clixml "$PSScriptRoot\$($d.query_file)-secrets.clixml";$env:PGPASSWORD=[Net.NetworkCredential]::new('',$s[$d.query_key]).Password
 $sql='EXPLAIN (ANALYZE,BUFFERS,FORMAT JSON) '+$d.query
 $output=$sql|& $p -X -w -A -t -h localhost -U $d.query_account -d ($d.database -split ' / ')[0] -v ON_ERROR_STOP=1 2>&1|Out-String
 $extra.Add([pscustomobject]@{group=$g;label='plan-after-related';account=$d.query_account;timestamp=[DateTimeOffset]::Now.ToString('o');database=($d.database -split ' / ')[0];exit_code=$LASTEXITCODE;sql=$sql;output=$output})
 $sql|Set-Content "$root\group-$g\plan-after-related.sql" -Encoding utf8;$output|Set-Content "$root\group-$g\plan-after-related.txt" -Encoding utf8
 Write-Output ('G'+$g+': analyzed related join inputs using verified MAINTAIN; updated plan captured.')
}
@($records)+@($extra.ToArray())|ConvertTo-Json -Depth 6|Set-Content "$root\execution-records.json" -Encoding utf8
Remove-Item Env:PGPASSWORD -ErrorAction SilentlyContinue
