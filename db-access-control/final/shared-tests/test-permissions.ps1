$ErrorActionPreference='Stop'
$s=Import-Clixml "$PSScriptRoot\batch4-secrets.clixml"
$p='E:\DATABASE\PostgreSQL\18\bin\psql.exe'
$r=[Collections.Generic.List[object]]::new()
function T($project,$db,$user,$key,$sql,$expected='Allowed'){
 $env:PGPASSWORD=[Net.NetworkCredential]::new('',$s[$key]).Password
 $q=('\set VERBOSITY verbose','BEGIN;',$sql,'ROLLBACK;') -join [Environment]::NewLine
 if($sql -like 'CREATE DATABASE*'){$q=$sql}
 $output=$q|& $p -X -w -a -h localhost -U $user -d $db -v ON_ERROR_STOP=1 2>&1|Out-String
 $exit=$LASTEXITCODE;$actual=if($exit -eq 0){'Allowed'}elseif($output -match '42501|permission denied|pg_hba.conf rejects connection'){'Denied'}else{'Other error'}
 $r.Add([pscustomobject]@{project=$project;account=$user;database=$db;sql=$sql;expected=$expected;actual=$actual;passed=($expected -eq $actual);output=$output})
}
T HealthBridge grp03_projectdb hb_app hb_app "INSERT INTO public.patients(first_name,last_name,date_of_birth,email) VALUES('Activity4','SQL Test','2000-01-01','activity4-sql@example.test'); UPDATE public.patients SET first_name='Updated' WHERE email='activity4-sql@example.test'; DELETE FROM public.patients WHERE email='activity4-sql@example.test';"
T HealthBridge grp03_projectdb hb_report hb_report 'SELECT count(*) FROM public.appointments;'
foreach($q in @("INSERT INTO public.patients(first_name,last_name,date_of_birth) VALUES('Readonly','Probe','2000-01-01');","UPDATE public.appointments SET status='Cancelled';","DELETE FROM public.appointments;","SELECT password_hash FROM public.staff_users;")){T HealthBridge grp03_projectdb hb_report hb_report $q Denied}
T HealthBridge grp03_projectdb hb_app hb_app "INSERT INTO public.specialties(specialty_name) VALUES('Forbidden reference write');" Denied
T HealthBridge grp03_projectdb hb_maintenance hb_maintenance "INSERT INTO public.specialties(specialty_name) VALUES('Activity4 Maintenance'); UPDATE public.specialties SET specialty_name='Activity4 Updated' WHERE specialty_name='Activity4 Maintenance'; DELETE FROM public.specialties WHERE specialty_name='Activity4 Updated';"
T SHIORI grp10_shioricafedb shiori_app shiori_app "INSERT INTO shioricafe_schema.category(category_name,is_drink_category) VALUES('Activity4 SQL test',false); UPDATE shioricafe_schema.category SET is_drink_category=true WHERE category_name='Activity4 SQL test'; DELETE FROM shioricafe_schema.category WHERE category_name='Activity4 SQL test';"
T SHIORI grp10_shioricafedb shiori_report shiori_report 'SELECT count(*) FROM shioricafe_schema.menu_item;'
foreach($q in @("INSERT INTO shioricafe_schema.category(category_name,is_drink_category) VALUES('Forbidden',false);","UPDATE shioricafe_schema.category SET is_drink_category=false;","DELETE FROM shioricafe_schema.category;","SELECT password_hash FROM shioricafe_schema.staff;")){T SHIORI grp10_shioricafedb shiori_report shiori_report $q Denied}
T CarRental car_rental_db app_runtime car_app "INSERT INTO public.vehicle_category(category_name,description) VALUES('Activity4 SQL category','Test'); UPDATE public.vehicle_category SET description='Updated' WHERE category_name='Activity4 SQL category';"
foreach($q in @("UPDATE public.audit_log SET action_type='Test';","DELETE FROM public.audit_log;","DELETE FROM public.vehicle_category;")){T CarRental car_rental_db app_runtime car_app $q Denied}
T CarRental car_rental_db car_report car_report 'SELECT count(*) FROM public.vehicle;'
foreach($q in @("SELECT password_hash FROM public.customer;","UPDATE public.vehicle SET make='Forbidden';","DELETE FROM public.vehicle;")){T CarRental car_rental_db car_report car_report $q Denied}
T Catering catering_management_db catering_app catering_app "INSERT INTO public.package(package_name,price_per_guest) VALUES('Activity4 SQL test',1); UPDATE public.package SET price_per_guest=2 WHERE package_name='Activity4 SQL test'; DELETE FROM public.package WHERE package_name='Activity4 SQL test';"
T Catering catering_management_db catering_report catering_report 'SELECT count(*) FROM public.package;'
foreach($q in @("INSERT INTO public.package(package_name,price_per_guest) VALUES('Forbidden',1);","UPDATE public.package SET price_per_guest=0;","DELETE FROM public.package;","SELECT password_hash FROM public.customer;","SELECT password_hash FROM public.admin;")){T Catering catering_management_db catering_report catering_report $q Denied}
$accounts=@(
 @('HealthBridge','grp03_projectdb','hb_app','hb_app','public'),
 @('HealthBridge','grp03_projectdb','hb_report','hb_report','public'),
 @('HealthBridge','grp03_projectdb','hb_maintenance','hb_maintenance','public'),
 @('SHIORI','grp10_shioricafedb','shiori_app','shiori_app','shioricafe_schema'),
 @('SHIORI','grp10_shioricafedb','shiori_report','shiori_report','shioricafe_schema'),
 @('CarRental','car_rental_db','app_runtime','car_app','public'),
 @('CarRental','car_rental_db','car_report','car_report','public'),
 @('CarRental','car_rental_db','car_dba','car_dba','public'),
 @('Catering','catering_management_db','catering_app','catering_app','public'),
 @('Catering','catering_management_db','catering_report','catering_report','public')
)
foreach($a in $accounts){
 T $a[0] $a[1] $a[2] $a[3] "CREATE TABLE $($a[4]).activity4_structure_probe(id int);" Denied
 T $a[0] $a[1] $a[2] $a[3] 'CREATE DATABASE activity4_denied_probe;' Denied
 T $a[0] $a[1] $a[2] $a[3] 'CREATE ROLE activity4_denied_probe;' Denied
 T $a[0] dropboxed_db $a[2] $a[3] 'SELECT current_user;' Denied
}
$r|ConvertTo-Json -Depth 4|Set-Content "$PSScriptRoot\..\outputs\Activity4-Additional-Testing\permission-results.json"
Remove-Item Env:PGPASSWORD
$r|Group-Object project,passed|Select-Object Name,Count
$r|Where-Object {-not $_.passed}|Select-Object project,sql,expected,actual,output|Format-List

