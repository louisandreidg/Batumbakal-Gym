if($env:ACTIVITY6_PRIVATE_DIR){
 $privateTarget=[IO.Path]::GetFullPath($env:ACTIVITY6_PRIVATE_DIR)
 $repoTarget=[IO.Path]::GetFullPath((Split-Path $PSScriptRoot -Parent))
 if($privateTarget.TrimEnd('\') -eq $repoTarget.TrimEnd('\') -or $privateTarget.StartsWith($repoTarget.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'Backup storage must be outside the repository.'}
}
$ErrorActionPreference='Stop'
$root=$PSScriptRoot;$private=$(if($env:ACTIVITY6_PRIVATE_DIR){[IO.Path]::GetFullPath($env:ACTIVITY6_PRIVATE_DIR)}else{throw 'Set ACTIVITY6_PRIVATE_DIR to a protected folder outside the repository.'});$cfg=Get-Content "$PSScriptRoot\project-config.json" -Raw|ConvertFrom-Json;$s=Import-Clixml "$private\credentials.clixml";$records=@()
$node='C:\Users\thedi\AppData\Roaming\fnm\node-versions\v26.13.0\installation\node.exe';$php=Join-Path $PSScriptRoot 'php-portable\php.exe';$ext=Join-Path $PSScriptRoot 'php-portable\ext'
$modules=@{'01'='C:\Users\thedi\Downloads\Dropboxed-main\src\db\pool.js';'03'='C:\Users\thedi\Documents\GRP03_PAWPAW\server\config\db.js';'08'=(Join-Path $PSScriptRoot 'catering-management-system\backend\db.js')}
foreach($g in @('01','03','05','07','08')){
 $d=$cfg|Where-Object group -eq $g;$pw=[Net.NetworkCredential]::new('',$s[($g+'-verify')]).Password
 $env:PGHOST='localhost';$env:PGPORT='5432';$env:PGDATABASE=$d.restore_db;$env:PGUSER=$d.verify_login;$env:PGPASSWORD=$pw;$env:PGSCHEMA=$d.schema;$env:PGSSL='false';Remove-Item Env:DATABASE_URL -ErrorAction SilentlyContinue
 $env:DB_HOST='localhost';$env:DB_PORT='5432';$env:DB_NAME=$d.restore_db;$env:DB_USER=$d.verify_login;$env:DB_PASSWORD=$pw;$env:DB_SSLMODE='disable';$env:DOTENV_CONFIG_QUIET='true'
 if($modules.ContainsKey($g)){$kind='Original Node.js connection module';$o=& $node "$PSScriptRoot\application-connection.cjs" $modules[$g] 2>&1|Out-String}
 elseif($g -eq '07'){$kind='Original PHP database.php db() function';$file=(Join-Path $PSScriptRoot 'grp07-applicant-management-system\config\database.php').Replace('\','/');$code="require '$file'; echo json_encode(db()->query('SELECT current_database() AS database,current_user AS account')->fetch());";$o=& $php -n -d "extension_dir=$ext" -d extension=pdo_pgsql -r $code 2>&1|Out-String}
 else{
  $kind='Original SHIORI db.php with separate private test configuration';$base=Join-Path $private 'shiori-driver';New-Item -ItemType Directory "$base\backend\config" -Force|Out-Null;Copy-Item (Join-Path $PSScriptRoot 'SHIORIcafe-new\backend\config\db.php') "$base\backend\config\db.php" -Force
  @("DB_HOST=localhost","DB_PORT=5432","DB_NAME=$($d.restore_db)","DB_USER=$($d.verify_login)","DB_PASSWORD=$pw","DB_SSLMODE=disable","DB_SCHEMA=$($d.schema)")|Set-Content "$base\.env" -Encoding ascii
  $file=(Join-Path $base 'backend\config\db.php').Replace('\','/');$code="require '$file'; echo json_encode(`$pdo->query('SELECT current_database() AS database,current_user AS account')->fetch(PDO::FETCH_ASSOC));";$o=& $php -n -d "extension_dir=$ext" -d extension=pdo_pgsql -r $code 2>&1|Out-String
 }
 $exit=$LASTEXITCODE;$match=$o.Contains($d.restore_db) -and $o.Contains($d.verify_login)
 $records+=[pscustomobject]@{group=$g;method=$kind;database=$d.restore_db;account=$d.verify_login;exit_code=$exit;passed=($exit -eq 0 -and $match);output=$o;checked_at=[DateTimeOffset]::Now.ToString('o')}
 $o|Set-Content "$root\group-$g\application-connection.txt" -Encoding utf8
 Write-Output ('G'+$g+' application connection module: '+($exit -eq 0 -and $match))
}
$records|ConvertTo-Json -Depth 6|Set-Content "$root\application-connection-results.json" -Encoding utf8
foreach($key in 'PGPASSWORD','DB_PASSWORD'){Remove-Item ('Env:'+$key) -ErrorAction SilentlyContinue}
