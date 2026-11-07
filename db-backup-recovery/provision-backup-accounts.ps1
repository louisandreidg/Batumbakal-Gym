if($env:ACTIVITY6_PRIVATE_DIR){
 $privateTarget=[IO.Path]::GetFullPath($env:ACTIVITY6_PRIVATE_DIR)
 $repoTarget=[IO.Path]::GetFullPath((Split-Path $PSScriptRoot -Parent))
 if($privateTarget.TrimEnd('\') -eq $repoTarget.TrimEnd('\') -or $privateTarget.StartsWith($repoTarget.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'Backup storage must be outside the repository.'}
}
$ErrorActionPreference='Stop'
$p='E:\DATABASE\PostgreSQL\18\bin\psql.exe';$adminpw=$env:PGPASSWORD
if(-not $adminpw){throw 'Supply the authorized administrator password through the process environment.'}
$root=$PSScriptRoot;$private=$(if($env:ACTIVITY6_PRIVATE_DIR){[IO.Path]::GetFullPath($env:ACTIVITY6_PRIVATE_DIR)}else{throw 'Set ACTIVITY6_PRIVATE_DIR to a protected folder outside the repository.'});$cfg=Get-Content "$PSScriptRoot\project-config.json" -Raw|ConvertFrom-Json
if(Test-Path -LiteralPath $private){throw 'Private run directory already exists; inspect before provisioning again.'}
New-Item -ItemType Directory $private -Force|Out-Null
$sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value
& icacls.exe $private /inheritance:r /grant:r "*${sid}:(OI)(CI)F" '*S-1-5-18:(OI)(CI)F' |Out-Null
if($LASTEXITCODE){throw 'Could not protect private backup directory'}
'*'|Set-Content "$private\.gitignore" -Encoding ascii
$s=@{};foreach($d in $cfg){foreach($kind in 'backup','restore','verify'){$s[($d.group+'-'+$kind)]=ConvertTo-SecureString ([Convert]::ToHexString([Security.Cryptography.RandomNumberGenerator]::GetBytes(24))) -AsPlainText -Force}}
$s|Export-Clixml "$private\credentials.clixml"
$env:PGCONNECT_TIMEOUT='5';$env:PGOPTIONS='-c statement_timeout=120000 -c lock_timeout=3000';$env:PGAPPNAME='COMP018_Activity6_Provision'
function Sql($db,$q){$env:PGPASSWORD=$adminpw;$o=$q|& $p -X -w -q -A -t -h localhost -U postgres -d $db -v ON_ERROR_STOP=1 2>&1|Out-String;if($LASTEXITCODE){throw $o};return $o}
$check=Sql postgres "SELECT rolname FROM pg_roles WHERE rolname LIKE 'a6_g%'; SELECT datname FROM pg_database WHERE datname LIKE 'a6_g%';"
if($check.Trim()){throw 'Activity 6 role/database names already exist. Do not overwrite.'}
$hba='E:\DATABASE\PostgreSQL\18\data\pg_hba.conf';$old=[IO.File]::ReadAllText($hba)
if($old.Contains('# BEGIN COMP018 Activity6')){throw 'Activity 6 policy already exists'}
[IO.File]::WriteAllText("$private\pg_hba.before.conf",$old)
$rules=[Collections.Generic.List[string]]::new();$rules.Add('# BEGIN COMP018 Activity6 - new accounts only')
foreach($d in $cfg){
 $roleSql=@"
CREATE ROLE $($d.backup_group) NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;
CREATE ROLE $($d.backup_login) LOGIN INHERIT NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;
CREATE ROLE $($d.restore_login) LOGIN INHERIT NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;
CREATE ROLE $($d.verify_login) LOGIN INHERIT NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;
GRANT $($d.backup_group) TO $($d.backup_login);
GRANT $($d.runtime) TO $($d.verify_login);
"@
 Sql postgres $roleSql|Out-Null
 $roleSql|Set-Content "$root\group-$($d.group)\activity6-roles.sql" -Encoding utf8
 foreach($kind in 'backup','restore','verify'){$login=$d.($kind+'_login');$pw=[Net.NetworkCredential]::new('',$s[($d.group+'-'+$kind)]).Password;Sql postgres "ALTER ROLE $login PASSWORD '$pw';"|Out-Null}
 $schemas=(Sql $d.source_db "SELECT nspname FROM pg_namespace WHERE nspname NOT LIKE 'pg_%' AND nspname<>'information_schema' ORDER BY 1;").Trim() -split '\r?\n'
 $grants=[Collections.Generic.List[string]]::new();$grants.Add("GRANT CONNECT ON DATABASE `"$($d.source_db)`" TO $($d.backup_group);")
 foreach($schema in $schemas){if($schema -notmatch '^[A-Za-z_][A-Za-z0-9_]*$'){throw 'Unexpected schema identifier'};$grants.Add("GRANT USAGE ON SCHEMA `"$schema`" TO $($d.backup_group);");$grants.Add("GRANT SELECT ON ALL TABLES IN SCHEMA `"$schema`" TO $($d.backup_group);");$grants.Add("GRANT SELECT ON ALL SEQUENCES IN SCHEMA `"$schema`" TO $($d.backup_group);")}
 Sql $d.source_db ($grants -join "`n")|Out-Null
 $grants|Set-Content "$root\group-$($d.group)\backup-read-grants.sql" -Encoding utf8
 foreach($db in @($d.restore_db,$d.preflight_db,$d.recovery_db)){
  Sql postgres "CREATE DATABASE $db OWNER $($d.restore_login) TEMPLATE template0;"|Out-Null
  Sql postgres "REVOKE ALL ON DATABASE $db FROM PUBLIC; GRANT CONNECT ON DATABASE $db TO $($d.restore_login),$($d.verify_login);"|Out-Null
 }
 $clones=@($d.restore_db,$d.preflight_db,$d.recovery_db)-join ','
 foreach($ip in @('127.0.0.1/32','::1/128')){$rules.Add("host `"$($d.source_db)`" $($d.backup_login) $ip scram-sha-256");$rules.Add("host $clones $($d.restore_login),$($d.verify_login) $ip scram-sha-256")}
 $users=@($d.backup_login,$d.restore_login,$d.verify_login)-join ','
 $rules.Add("host all $users 0.0.0.0/0 reject");$rules.Add("host all $users ::/0 reject")
 Write-Output ('Provisioned G'+$d.group+' backup role and empty isolated targets.')
}
$rules.Add('# END COMP018 Activity6');$block=$rules -join "`r`n"
[IO.File]::WriteAllText($hba,$block+"`r`n"+$old)
$errors=Sql postgres 'SELECT line_number,error FROM pg_hba_file_rules WHERE error IS NOT NULL;'
if($errors.Trim()){[IO.File]::WriteAllText($hba,$old);Sql postgres 'SELECT pg_reload_conf();'|Out-Null;throw 'Connection policy parse error; previous policy restored.'}
Sql postgres 'SELECT pg_reload_conf();'|Out-Null
$block|Set-Content "$root\activity6-connection-policy.snippet" -Encoding utf8
& icacls.exe $private|Set-Content "$private\storage-acl.txt" -Encoding utf8
Remove-Item Env:PGPASSWORD -ErrorAction SilentlyContinue
'Provisioning finished. Original application data and existing account passwords are unchanged.'
