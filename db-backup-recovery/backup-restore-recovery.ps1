param([string[]]$Groups=@('01','02','03','04','05','06','07','08','10','11'),[string]$RunTag='run1',[switch]$ResumeRestored,[switch]$ReuseArchive)
if($env:ACTIVITY6_PRIVATE_DIR){
 $privateTarget=[IO.Path]::GetFullPath($env:ACTIVITY6_PRIVATE_DIR)
 $repoTarget=[IO.Path]::GetFullPath((Split-Path $PSScriptRoot -Parent))
 if($privateTarget.TrimEnd('\') -eq $repoTarget.TrimEnd('\') -or $privateTarget.StartsWith($repoTarget.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'Backup storage must be outside the repository.'}
}
$ErrorActionPreference='Stop'
$bin='E:\DATABASE\PostgreSQL\18\bin';$root=$PSScriptRoot;$private=$(if($env:ACTIVITY6_PRIVATE_DIR){[IO.Path]::GetFullPath($env:ACTIVITY6_PRIVATE_DIR)}else{throw 'Set ACTIVITY6_PRIVATE_DIR to a protected folder outside the repository.'})
$cfg=Get-Content "$PSScriptRoot\project-config.json" -Raw|ConvertFrom-Json;$secrets=Import-Clixml "$private\credentials.clixml"
$records=[Collections.Generic.List[object]]::new();$results=[Collections.Generic.List[object]]::new()
if(Test-Path "$root\execution-records.json"){foreach($v in @(Get-Content "$root\execution-records.json" -Raw|ConvertFrom-Json)){$records.Add($v)}}
if(Test-Path "$root\results.json"){foreach($v in @(Get-Content "$root\results.json" -Raw|ConvertFrom-Json)){$results.Add($v)}}
$env:PGCONNECT_TIMEOUT='5';$env:PGAPPNAME='COMP018_Activity6';$env:PGOPTIONS='-c statement_timeout=120000 -c lock_timeout=3000 -c timezone=UTC -c datestyle=ISO,MDY';$env:PGPASSFILE=Join-Path $private 'no-password-file'
function Auth($d,$kind){$env:PGPASSWORD=[Net.NetworkCredential]::new('',$secrets[($d.group+'-'+$kind)]).Password;return $d.($kind+'_login')}
function Save(){ $records.ToArray()|ConvertTo-Json -Depth 8|Set-Content "$root\execution-records.json" -Encoding utf8;$results.ToArray()|ConvertTo-Json -Depth 15|Set-Content "$root\results.json" -Encoding utf8 }
function Sql($d,$label,$kind,$db,$sql,$AllowFailure=$false){
 $u=Auth $d $kind;$output=$sql|& "$bin\psql.exe" -X -w -q -A -t -h localhost -U $u -d $db -v ON_ERROR_STOP=1 2>&1|Out-String;$code=$LASTEXITCODE
 $records.Add([pscustomobject]@{group=$d.group;run=$RunTag;label=$label;tool='psql';account=$u;database=$db;timestamp=[DateTimeOffset]::Now.ToString('o');exit_code=$code;sql=$sql;output=$output})
 $prefix="$root\group-$($d.group)\$RunTag-$label";$sql|Set-Content ($prefix+'.sql') -Encoding utf8;$output|Set-Content ($prefix+'.txt') -Encoding utf8
 if($code -and -not $AllowFailure){throw "$label failed: $output"}
 return [pscustomobject]@{exit_code=$code;output=$output}
}
function Dump($d,$label,$kind,$db){
 $u=Auth $d $kind;$filename="g$($d.group)_$($label)_$RunTag.dump";$path=Join-Path $private $filename
 if(Test-Path -LiteralPath $path){throw 'Archive path already exists; refusing overwrite.'}
 $args=@('-w','-h','localhost','-U',$u,'-Fc','--verbose','-d',$db)
 $psi=[Diagnostics.ProcessStartInfo]::new();$psi.FileName="$bin\pg_dump.exe";$psi.UseShellExecute=$false;$psi.CreateNoWindow=$true;$psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true
 foreach($a in $args){$psi.ArgumentList.Add($a)}
 $process=[Diagnostics.Process]::new();$process.StartInfo=$psi;$start=[DateTimeOffset]::Now;$sw=[Diagnostics.Stopwatch]::StartNew();$process.Start()|Out-Null;$errTask=$process.StandardError.ReadToEndAsync();$memory=[IO.MemoryStream]::new();$process.StandardOutput.BaseStream.CopyTo($memory);$process.WaitForExit();$sw.Stop();$output=$errTask.GetAwaiter().GetResult();$code=$process.ExitCode
 if($code){throw "pg_dump failed: $output"};$data=$memory.ToArray();if($data.Length -lt 5 -or [Text.Encoding]::ASCII.GetString($data,0,5) -ne 'PGDMP'){throw 'Invalid archive header'}
 [IO.File]::WriteAllBytes($path,$data);(Get-Item -LiteralPath $path).IsReadOnly=$true;$sha=(Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLower()
 $meta=[pscustomobject]@{file=$filename;bytes=$data.Length;sha256=$sha;database=$db;account=$u;created_at=$start.ToString('o');duration_seconds=[Math]::Round($sw.Elapsed.TotalSeconds,3)}
 $listing=& "$bin\pg_restore.exe" --list $path 2>&1|Out-String;if($LASTEXITCODE){throw 'Archive listing failed'}
 $output|Set-Content "$root\group-$($d.group)\$RunTag-$label-dump.txt" -Encoding utf8;$listing|Set-Content "$root\group-$($d.group)\$RunTag-$label-archive-list.txt" -Encoding utf8
 $records.Add([pscustomobject]@{group=$d.group;run=$RunTag;label=$label+'-dump';tool='pg_dump';account=$u;database=$db;timestamp=$meta.created_at;exit_code=$code;arguments=$args;archive=$meta;output=$output})
 return $meta
}
function Restore($d,$label,$db,$archive){
 if($db -notin @($d.restore_db,$d.preflight_db,$d.recovery_db)){throw 'Restore target is not a designated disposable database'}
 $empty=Sql $d ($label+'-empty-check') restore $db "SELECT count(*) FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE c.relkind IN('r','p') AND n.nspname NOT IN('pg_catalog','information_schema');"
 if($empty.output.Trim() -ne '0'){throw 'Restore target is not empty; refusing overwrite.'}
 $path=Join-Path $private $archive.file;if((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLower() -ne $archive.sha256){throw 'Archive checksum changed'}
 $toc=& "$bin\pg_restore.exe" --list $path 2>&1
 if($LASTEXITCODE){throw 'Cannot inspect archive before restore'}
 $filtered=@($toc|ForEach-Object {if($_ -notmatch '^;' -and $_ -match '\sDEFAULT ACL\s'){'; Omitted for explicit isolated-owner replay: '+$_}else{$_}})
 $listPath="$root\group-$($d.group)\$RunTag-$label-restore-list.txt"
 [IO.File]::WriteAllLines($listPath,[string[]]$filtered,[Text.UTF8Encoding]::new($false))
 $u=Auth $d restore;$args=@('-w','-h','localhost','-U',$u,'--verbose','--exit-on-error','--single-transaction','--no-owner','--use-list',$listPath,'-d',$db,$path)
 $sw=[Diagnostics.Stopwatch]::StartNew();$o=& "$bin\pg_restore.exe" @args 2>&1|Out-String;$code=$LASTEXITCODE;$sw.Stop()
 $records.Add([pscustomobject]@{group=$d.group;run=$RunTag;label=$label;tool='pg_restore';account=$u;database=$db;timestamp=[DateTimeOffset]::Now.ToString('o');exit_code=$code;duration_seconds=[Math]::Round($sw.Elapsed.TotalSeconds,3);arguments=$args;output=$o})
 $o|Set-Content "$root\group-$($d.group)\$RunTag-$label.txt" -Encoding utf8
 if($code){throw "Restore failed: $o"}
 if($d.default_acl_sql.Trim()){$applied=Sql $d ($label+'-default-acl-replay') restore $db $d.default_acl_sql;if($applied.exit_code){throw 'Default ACL replay failed'}}
 return [Math]::Round($sw.Elapsed.TotalSeconds,3)
}
function SnapshotSql($d){
 $names=(@($d.original_role_names)+@($d.backup_group)|ForEach-Object {"'$_'"})-join ','
 $owners=(@('postgres')+@($d.old_owner_names)|ForEach-Object {"'$_'"})-join ','
 return @"
SET default_transaction_read_only=on;
SELECT jsonb_build_object('kind','environment','database',current_database(),'account',current_user,'version',version(),'timestamp',clock_timestamp());
SELECT jsonb_build_object('kind','catalog',
 'relations',(SELECT COALESCE(jsonb_agg(to_jsonb(r)),'[]') FROM (SELECT n.nspname,c.relname,c.relkind,c.relrowsecurity,c.relforcerowsecurity FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname NOT LIKE 'pg_%' AND n.nspname NOT IN('information_schema','activity6_probe') AND c.relkind IN('r','p','v','m','S') ORDER BY 1,2)r),
 'constraints',(SELECT COALESCE(jsonb_agg(to_jsonb(r)),'[]') FROM (SELECT n.nspname,c.relname,k.conname,k.contype,pg_get_constraintdef(k.oid) AS definition,k.convalidated FROM pg_constraint k JOIN pg_class c ON c.oid=k.conrelid JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname NOT LIKE 'pg_%' AND n.nspname NOT IN('information_schema','activity6_probe') ORDER BY 1,2,3)r),
 'indexes',(SELECT COALESCE(jsonb_agg(to_jsonb(r)),'[]') FROM (SELECT n.nspname,c.relname,pg_get_indexdef(i.indexrelid) AS definition,i.indisvalid FROM pg_index i JOIN pg_class c ON c.oid=i.indexrelid JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname NOT LIKE 'pg_%' AND n.nspname NOT IN('information_schema','activity6_probe') ORDER BY 1,2)r),
 'views',(SELECT COALESCE(jsonb_agg(to_jsonb(r)),'[]') FROM (SELECT schemaname,viewname,definition FROM pg_views WHERE schemaname NOT LIKE 'pg_%' AND schemaname NOT IN('information_schema','activity6_probe') ORDER BY 1,2)r),
 'functions',(SELECT COALESCE(jsonb_agg(to_jsonb(r)),'[]') FROM (SELECT n.nspname,p.proname,pg_get_function_identity_arguments(p.oid) AS args,pg_get_functiondef(p.oid) AS definition FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname NOT LIKE 'pg_%' AND n.nspname NOT IN('information_schema','activity6_probe') AND p.prokind IN('f','p') AND NOT EXISTS(SELECT 1 FROM pg_depend x WHERE x.classid='pg_proc'::regclass AND x.objid=p.oid AND x.deptype='e') ORDER BY 1,2,3)r),
 'extensions',(SELECT jsonb_agg(to_jsonb(r)) FROM (SELECT extname,extversion FROM pg_extension ORDER BY 1)r),
 'large_object_count',(SELECT count(*) FROM pg_largeobject_metadata));
WITH relevant AS(SELECT oid FROM pg_roles WHERE rolname IN($names) UNION SELECT roleid FROM pg_auth_members WHERE member IN(SELECT oid FROM pg_roles WHERE rolname IN($names)))
SELECT jsonb_build_object('kind','acl',
 'relations',(SELECT COALESCE(jsonb_agg(to_jsonb(r)),'[]') FROM (SELECT n.nspname,c.relname,CASE WHEN a.grantee=0 THEN 'PUBLIC' ELSE pg_get_userbyid(a.grantee) END AS grantee,a.privilege_type,a.is_grantable FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace CROSS JOIN LATERAL aclexplode(c.relacl) a WHERE n.nspname NOT LIKE 'pg_%' AND n.nspname NOT IN('information_schema','activity6_probe') AND c.relkind IN('r','p','S','v','m') AND (a.grantee=0 OR a.grantee IN(SELECT oid FROM relevant)) AND (a.grantee=0 OR pg_get_userbyid(a.grantee) NOT IN($owners)) ORDER BY 1,2,3,4,5)r),
 'columns',(SELECT COALESCE(jsonb_agg(to_jsonb(r)),'[]') FROM (SELECT n.nspname,c.relname,t.attname,pg_get_userbyid(a.grantee) AS grantee,a.privilege_type,a.is_grantable FROM pg_attribute t JOIN pg_class c ON c.oid=t.attrelid JOIN pg_namespace n ON n.oid=c.relnamespace CROSS JOIN LATERAL aclexplode(t.attacl) a WHERE n.nspname NOT LIKE 'pg_%' AND n.nspname NOT IN('information_schema','activity6_probe') AND a.grantee IN(SELECT oid FROM relevant) AND pg_get_userbyid(a.grantee) NOT IN($owners) ORDER BY 1,2,3,4,5,6)r));
SELECT format('SELECT jsonb_build_object(''kind'',''data'',''name'',%L,''rows'',count(*),''md5'',md5(COALESCE(string_agg(to_jsonb(t)::text,E''\\n'' ORDER BY to_jsonb(t)::text),''''))) FROM %I.%I t;',schemaname||'.'||tablename,schemaname,tablename) FROM pg_tables WHERE schemaname NOT LIKE 'pg_%' AND schemaname NOT IN('information_schema','activity6_probe') ORDER BY schemaname,tablename
\gexec
SELECT format('SELECT jsonb_build_object(''kind'',''sequence'',''name'',%L,''last_value'',last_value,''is_called'',is_called) FROM %I.%I;',sequence_schema||'.'||sequence_name,sequence_schema,sequence_name) FROM (SELECT n.nspname AS sequence_schema,c.relname AS sequence_name FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE c.relkind='S' AND n.nspname NOT LIKE 'pg_%' AND n.nspname NOT IN('information_schema','activity6_probe')) all_sequences ORDER BY sequence_schema,sequence_name
\gexec
"@
}
function Rows($output){return @($output -split '\r?\n'|Where-Object {$_.Trim().StartsWith('{')}|ForEach-Object {$_|ConvertFrom-Json})}
function NormalizeArrayCheck([string]$text){
 $pos=0
 while($pos -lt $text.Length){
  $m=[regex]::Match($text.Substring($pos),'\b(?:ANY|ALL)\s*\(')
  if(-not $m.Success){break}
  $open=$pos+$m.Index+$m.Length-1;$depth=1;$quoted=$false;$end=$open+1
  for(;$end -lt $text.Length;$end++){
   $ch=$text[$end]
   if($ch -eq "'"){
    if($quoted -and $end+1 -lt $text.Length -and $text[$end+1] -eq "'"){$end++;continue}
    $quoted=-not $quoted;continue
   }
   if(-not $quoted){if($ch -eq '('){$depth++};if($ch -eq ')'){$depth--;if($depth -eq 0){break}}}
  }
  if($depth -ne 0){break}
  $inner=$text.Substring($open+1,$end-$open-1);$parts=[regex]::Split($inner,"('(?:''|[^'])*')")
  for($i=0;$i -lt $parts.Count;$i+=2){$parts[$i]=$parts[$i] -replace '::text\[\]|::text\b|::character varying\b(?!\s*\()','';$parts[$i]=$parts[$i] -replace '[()\s]',''}
  $shape='';for($i=0;$i -lt $parts.Count;$i++){if($i%2){$shape+='?'}else{$shape+=$parts[$i]}}
  if($shape -match '^ARRAY\[\?(,\?)*\]$'){
   $canonical=$parts -join '';$text=$text.Substring(0,$open+1)+$canonical+$text.Substring($end);$pos=$open+1+$canonical.Length+1
  }else{$pos=$end+1}
 }
 return $text
}
function Fingerprint($output){
 $rows=@(Rows $output|Where-Object kind -ne 'environment')
 foreach($row in $rows|Where-Object kind -eq 'catalog'){
  foreach($constraint in $row.constraints){if($constraint.contype -eq 'c'){$constraint.definition=NormalizeArrayCheck $constraint.definition}}
 }
 return ($rows|ConvertTo-Json -Depth 50 -Compress)
}

foreach($d in $cfg|Where-Object {$_.group -in $Groups}){
 $r=[ordered]@{group=$d.group;run=$RunTag;name=$d.name;source=$d.source_db;restore=$d.restore_db;preflight=$d.preflight_db;recovery=$d.recovery_db;started_at=[DateTimeOffset]::Now.ToString('o');status='Failed';limitations=@()}
 try{
  $defaultQuery=@"
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I%s REVOKE ALL ON %s FROM PUBLIC;','$($d.restore_login)',CASE WHEN n.nspname IS NULL THEN '' ELSE format(' IN SCHEMA %I',n.nspname) END,CASE d.defaclobjtype WHEN 'r' THEN 'TABLES' WHEN 'S' THEN 'SEQUENCES' WHEN 'f' THEN 'FUNCTIONS' WHEN 'T' THEN 'TYPES' WHEN 'n' THEN 'SCHEMAS' END) FROM pg_default_acl d LEFT JOIN pg_namespace n ON n.oid=d.defaclnamespace ORDER BY d.oid;
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I%s GRANT %s ON %s TO %s%s;','$($d.restore_login)',CASE WHEN n.nspname IS NULL THEN '' ELSE format(' IN SCHEMA %I',n.nspname) END,a.privilege_type,CASE d.defaclobjtype WHEN 'r' THEN 'TABLES' WHEN 'S' THEN 'SEQUENCES' WHEN 'f' THEN 'FUNCTIONS' WHEN 'T' THEN 'TYPES' WHEN 'n' THEN 'SCHEMAS' END,CASE WHEN a.grantee=0 THEN 'PUBLIC' ELSE quote_ident(pg_get_userbyid(a.grantee)) END,CASE WHEN a.is_grantable THEN ' WITH GRANT OPTION' ELSE '' END) FROM pg_default_acl d LEFT JOIN pg_namespace n ON n.oid=d.defaclnamespace CROSS JOIN LATERAL aclexplode(d.defaclacl) a WHERE a.grantee<>d.defaclrole ORDER BY d.oid,a.grantee,a.privilege_type;
"@
  $dp=Sql $d default-acl-plan backup $d.source_db $defaultQuery
  $d|Add-Member -NotePropertyName default_acl_sql -NotePropertyValue $dp.output -Force
  $snapshot=SnapshotSql $d
  $before=Sql $d source-before backup $d.source_db $snapshot
  if($ResumeRestored -or $ReuseArchive){
   $prior=@($results|Where-Object {$_.group -eq $d.group -and $_.source_archive})|Select-Object -Last 1
   if(-not $prior){$saved=@($records|Where-Object {$_.group -eq $d.group -and $_.label -eq 'source-dump'})|Select-Object -Last 1;if($saved){$prior=[pscustomobject]@{source_archive=$saved.archive}}}
   if(-not $prior){throw 'No prior archived restore exists for resume'}
   $archive=$prior.source_archive
   if((Get-FileHash -LiteralPath (Join-Path $private $archive.file) -Algorithm SHA256).Hash.ToLower() -ne $archive.sha256){throw 'Prior archive checksum mismatch'}
   $r.source_archive=$archive
   if($ResumeRestored){$r.restore_seconds=(@($records|Where-Object {$_.group -eq $d.group -and $_.label -eq 'initial-restore' -and $_.exit_code -eq 0})|Select-Object -Last 1).duration_seconds}else{$r.restore_seconds=Restore $d initial-restore $d.restore_db $archive}
  }else{$archive=Dump $d source backup $d.source_db;$r.source_archive=$archive;$r.restore_seconds=Restore $d initial-restore $d.restore_db $archive}
  $r.source_archive=$archive
  $restored=Sql $d restored-fingerprint restore $d.restore_db $snapshot
  if((Fingerprint $before.output) -ne (Fingerprint $restored.output)){throw 'Source/restored data, object, sequence or ACL fingerprints differ'}
  $r.restored_data_objects_acl_match=$true
  $query=$d.query.Trim().TrimEnd(';');$asof=[DateTimeOffset]::Now.ToString('o');$query=$query -replace '\bCURRENT_TIMESTAMP\b',("TIMESTAMPTZ '$asof'") -replace '\bCURRENT_DATE\b',("DATE '$($asof.Substring(0,10))'")
  $qsql="WITH q AS ($query) SELECT jsonb_build_object('rows',count(*),'md5',md5(COALESCE(string_agg(to_jsonb(q)::text,E'\n' ORDER BY to_jsonb(q)::text),''))) FROM q;"
  $qsource=Sql $d representative-source backup $d.source_db $qsql
  $qrestore=Sql $d representative-restored verify $d.restore_db $qsql
  if($qsource.output.Trim() -ne $qrestore.output.Trim()){throw 'Representative query result fingerprint differs'}
  $r.representative_query_match=$true
  $denied=Sql $d denied-schema-create verify $d.restore_db "BEGIN; CREATE TABLE `"$($d.schema)`".activity6_denied_probe(id int); ROLLBACK;" $true
  if(-not $denied.exit_code -or $denied.output -notmatch 'permission denied'){throw 'Expected runtime schema-CREATE denial not verified'}
  $r.permitted_and_denied_verified=$true
  $verifySource=Sql $d verifier-source-isolation verify $d.source_db 'SELECT current_database();' $true
  $restoreSource=Sql $d restorer-source-isolation restore $d.source_db 'SELECT current_database();' $true
  $backupClone=Sql $d backup-clone-isolation backup $d.restore_db 'SELECT current_database();' $true
  if(@($verifySource,$restoreSource,$backupClone)|Where-Object {$_.exit_code -eq 0 -or $_.output -notmatch 'pg_hba.conf rejects connection'}){throw 'Account database isolation failed'}
  $r.account_isolation_verified=$true
  $tag="COMP018-A6-G$($d.group)-20261107";$r.fixture_tag=$tag
  $fixtureSql="DO `$guard`$ BEGIN IF current_database()<>'$($d.restore_db)' THEN RAISE EXCEPTION 'Wrong incident target'; END IF; END `$guard`$; CREATE SCHEMA activity6_probe; CREATE TABLE activity6_probe.recovery_record(probe_id integer PRIMARY KEY,marker text NOT NULL UNIQUE); INSERT INTO activity6_probe.recovery_record VALUES(1,'$tag'); SELECT jsonb_build_object('database',current_database(),'probe_id',probe_id,'marker',marker) FROM activity6_probe.recovery_record;"
  $stateBefore=Sql $d incident-before restore $d.restore_db $fixtureSql
  $checkpoint=Dump $d checkpoint restore $d.restore_db;$r.checkpoint_archive=$checkpoint
  $r.preflight_seconds=Restore $d checkpoint-preflight $d.preflight_db $checkpoint
  $probeRead="SELECT jsonb_build_object('rows',count(*),'marker',min(marker)) FROM activity6_probe.recovery_record WHERE probe_id=1 AND marker='$tag';"
  $preflight=Sql $d preflight-probe restore $d.preflight_db $probeRead
  $pj=$preflight.output|ConvertFrom-Json;if($pj.rows -ne 1 -or $pj.marker -ne $tag){throw 'Verified checkpoint does not contain fixture'}
  $preflightFingerprint=Sql $d preflight-fingerprint restore $d.preflight_db $snapshot
  if((Fingerprint $restored.output) -ne (Fingerprint $preflightFingerprint.output)){throw 'Checkpoint changed application data or schema'}
  $r.backup_verified_before_incident=$true;$incidentAt=[DateTimeOffset]::Now;$r.incident_at=$incidentAt.ToString('o')
  $loss=Sql $d incident-delete restore $d.restore_db "DO `$guard`$ BEGIN IF current_database()<>'$($d.restore_db)' THEN RAISE EXCEPTION 'Wrong incident target'; END IF; END `$guard`$; DELETE FROM activity6_probe.recovery_record WHERE probe_id=1 AND marker='$tag'; $probeRead"
  if(($loss.output|ConvertFrom-Json).rows -ne 0){throw 'Disposable record deletion not verified'}
  $r.recovery_seconds=Restore $d incident-recovery $d.recovery_db $checkpoint
  $recovered=Sql $d recovered-probe restore $d.recovery_db $probeRead
  $j=$recovered.output|ConvertFrom-Json;if($j.rows -ne 1 -or $j.marker -ne $tag){throw 'Expected fixture was not recovered'}
  $final=Sql $d recovered-fingerprint restore $d.recovery_db $snapshot
  if((Fingerprint $restored.output) -ne (Fingerprint $final.output)){throw 'Recovered application data differs'}
  $after=Sql $d source-after backup $d.source_db $snapshot
  if((Fingerprint $before.output) -ne (Fingerprint $after.output)){throw 'Source changed during this project test; investigate concurrency'}
  if((Get-FileHash -LiteralPath (Join-Path $private $archive.file) -Algorithm SHA256).Hash.ToLower() -ne $archive.sha256){throw 'Initial backup changed'}
  $r.source_unchanged=$true;$r.recovery_result='Recovered';$r.recovery_elapsed_seconds=[Math]::Round(([DateTimeOffset]::Now-$incidentAt).TotalSeconds,3)
  $r.status='Success';$r.finished_at=[DateTimeOffset]::Now.ToString('o')
  $r.limitations=@('Restored object ownership intentionally maps to the isolated restore login; original database owners were not changed.','Roles already existed in this cluster; a fresh-cluster role reconstruction remains an operational prerequisite.','Application query/account behavior was checked; full web applications were not retargeted.','Checkpoint backup includes the disposable fixture; the initial source backup predates that fixture.')
  Write-Output ('G'+$d.group+': backup, restore, access checks and guarded recovery succeeded.')
 }catch{$r.error=$_.Exception.Message;Write-Output ('G'+$d.group+': '+$r.error.Substring(0,[Math]::Min(450,$r.error.Length)))}
 $results.Add([pscustomobject]$r);Save
}
Remove-Item Env:PGPASSWORD -ErrorAction SilentlyContinue
