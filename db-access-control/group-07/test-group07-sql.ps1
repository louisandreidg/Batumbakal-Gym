param([Parameter(Mandatory=$true)][string]$CredentialFile)
$ErrorActionPreference='Stop'
$s=Import-Clixml $CredentialFile
$p='E:\DATABASE\PostgreSQL\18\bin\psql.exe'
$tests=[Collections.Generic.List[object]]::new()
function Test-Sql($user,$key,$sql,$expected='Allowed',$db='grp07_applicantdb'){
 $env:PGPASSWORD=[Net.NetworkCredential]::new('',$s[$key]).Password
 $q=('\set VERBOSITY verbose','BEGIN;',$sql,'ROLLBACK;') -join [Environment]::NewLine
 if($sql -like 'CREATE DATABASE*'){$q=$sql}
 $output=$q | & $p -X -w -a -h localhost -U $user -d $db -v ON_ERROR_STOP=1 2>&1 | Out-String
 $exit=$LASTEXITCODE
 $actual=if($exit -eq 0){'Allowed'}elseif($output -match '42501|permission denied|pg_hba.conf rejects connection'){'Denied'}else{'Other error'}
 $tests.Add([pscustomobject]@{account=$user;database=$db;sql=$sql;expected=$expected;actual=$actual;passed=($expected -eq $actual);output=$output})
}
foreach($table in 'department','position','applicant','application_status','application','interview','requirement','applicant_requirement'){
 Test-Sql grp07_app app "SELECT count(*) FROM public.$table;"
 Test-Sql grp07_readonly readonly "SELECT count(*) FROM public.$table;"
}
$fixture=@'
INSERT INTO public.department(department_name) VALUES('Activity4 SQL test');
INSERT INTO public.position(department_id,position_title) SELECT department_id,'Activity4 SQL test' FROM public.department WHERE department_name='Activity4 SQL test';
INSERT INTO public.applicant(first_name,last_name,email,phone) VALUES('Activity4','Test','activity4-sql@example.test','000');
INSERT INTO public.application(applicant_id,position_id,status_id) SELECT a.applicant_id,p.position_id,1 FROM public.applicant a,public.position p WHERE a.email='activity4-sql@example.test' AND p.position_title='Activity4 SQL test';
INSERT INTO public.interview(application_id,interview_date) SELECT application_id,'2099-01-01 10:00' FROM public.application WHERE applicant_id=(SELECT applicant_id FROM public.applicant WHERE email='activity4-sql@example.test');
INSERT INTO public.requirement(requirement_name) VALUES('Activity4 SQL test');
INSERT INTO public.applicant_requirement(applicant_id,requirement_id) SELECT a.applicant_id,r.requirement_id FROM public.applicant a,public.requirement r WHERE a.email='activity4-sql@example.test' AND r.requirement_name='Activity4 SQL test';
'@
Test-Sql grp07_app app $fixture
$update=@'
UPDATE public.department SET description='Updated' WHERE department_name='Activity4 SQL test';
UPDATE public.position SET description='Updated' WHERE position_title='Activity4 SQL test';
UPDATE public.applicant SET phone='111' WHERE email='activity4-sql@example.test';
UPDATE public.application SET status_id=2 WHERE applicant_id=(SELECT applicant_id FROM public.applicant WHERE email='activity4-sql@example.test');
UPDATE public.interview SET notes='Updated' WHERE application_id IN (SELECT application_id FROM public.application WHERE applicant_id=(SELECT applicant_id FROM public.applicant WHERE email='activity4-sql@example.test'));
UPDATE public.requirement SET description='Updated' WHERE requirement_name='Activity4 SQL test';
UPDATE public.applicant_requirement SET remarks='Updated' WHERE applicant_id=(SELECT applicant_id FROM public.applicant WHERE email='activity4-sql@example.test');
'@
Test-Sql grp07_app app ($fixture+$update)
$delete=@'
DELETE FROM public.applicant_requirement WHERE applicant_id=(SELECT applicant_id FROM public.applicant WHERE email='activity4-sql@example.test');
DELETE FROM public.interview WHERE application_id IN (SELECT application_id FROM public.application WHERE applicant_id=(SELECT applicant_id FROM public.applicant WHERE email='activity4-sql@example.test'));
DELETE FROM public.application WHERE applicant_id=(SELECT applicant_id FROM public.applicant WHERE email='activity4-sql@example.test');
DELETE FROM public.applicant WHERE email='activity4-sql@example.test';
DELETE FROM public.position WHERE position_title='Activity4 SQL test';
DELETE FROM public.department WHERE department_name='Activity4 SQL test';
DELETE FROM public.requirement WHERE requirement_name='Activity4 SQL test';
'@
Test-Sql grp07_app app ($fixture+$delete)
foreach($sql in "CREATE TABLE public.activity4_probe(id int);","ALTER TABLE public.department ADD COLUMN activity4_probe int;","DROP TABLE public.applicant;","CREATE DATABASE grp07_permission_probe;","CREATE ROLE grp07_permission_probe;","INSERT INTO public.application_status(status_name) VALUES('Probe');"){
 Test-Sql grp07_app app $sql Denied
}
foreach($sql in "INSERT INTO public.department(department_name) VALUES('Readonly probe');","UPDATE public.department SET description='probe';","DELETE FROM public.department;","CREATE TABLE public.activity4_probe(id int);","CREATE DATABASE grp07_permission_probe;","CREATE ROLE grp07_permission_probe;"){
 Test-Sql grp07_readonly readonly $sql Denied
}
Test-Sql grp07_owner owner 'CREATE TABLE public.activity4_owner_probe(id int); ALTER TABLE public.activity4_owner_probe ADD COLUMN note text; DROP TABLE public.activity4_owner_probe;'
foreach($a in @(@('grp07_app','app'),@('grp07_readonly','readonly'),@('grp07_owner','owner'))){
 foreach($db in 'dropboxed_db','group3_Pawpaw','grp99_gymdb','grp02_event_management_db'){Test-Sql $a[0] $a[1] 'SELECT current_user;' Denied $db}
}
Remove-Item Env:PGPASSWORD
$tests | ConvertTo-Json -Depth 4 | Set-Content "$PSScriptRoot\evidence\group07-sql-results.json"
$tests | Group-Object passed | Select-Object Name,Count
$tests | Where-Object {-not $_.passed} | Select-Object account,sql,actual


