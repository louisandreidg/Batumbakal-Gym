param([Parameter(Mandatory=$true)][string]$CredentialFile)
$ErrorActionPreference='Stop'
$psql='E:\DATABASE\PostgreSQL\18\bin\psql.exe'
$secrets=Import-Clixml $CredentialFile
$results=[Collections.Generic.List[object]]::new()
$evidence="$PSScriptRoot\evidence"
$fixture=@'
INSERT INTO venue(venue_name,location,capacity) VALUES ('activity4-permission-probe','Test',10);
INSERT INTO participant(student_number,first_name,last_name) VALUES ('activity4-probe','Test','Only');
INSERT INTO user_account(username,password_hash,first_name,last_name,role_id) SELECT 'activity4-probe','not-a-login-hash','Test','Only',role_id FROM role WHERE role_name='Event Organizer';
INSERT INTO event(event_name,event_date,start_time,end_time,event_status,organizer_id,venue_id) SELECT 'activity4-probe','2099-01-01','09:00','10:00','Upcoming',u.user_id,v.venue_id FROM user_account u,venue v WHERE u.username='activity4-probe' AND v.venue_name='activity4-permission-probe';
INSERT INTO event_schedule(event_id,activity_name,start_time,end_time) SELECT event_id,'Probe','09:00','09:30' FROM event WHERE event_name='activity4-probe';
INSERT INTO event_assignment(event_id,staff_name,assignment_status) SELECT event_id,'Probe','Pending' FROM event WHERE event_name='activity4-probe';
INSERT INTO attendance(event_id,participant_id,attendance_status) SELECT e.event_id,p.participant_id,'Present' FROM event e,participant p WHERE e.event_name='activity4-probe' AND p.student_number='activity4-probe';
INSERT INTO audit_log(user_id,action_performed,affected_table,affected_record_id) SELECT user_id,'Created','venue',0 FROM user_account WHERE username='activity4-probe';
'@
function Test-Sql($account,$key,$label,$statement,$allowed=$true,$db='grp02_event_management_db',$setup='') {
 $env:PGPASSWORD=[Net.NetworkCredential]::new('',$secrets[$key]).Password
 $sql=('\set VERBOSITY verbose','BEGIN;','SET LOCAL search_path=school_event_management_db,public;',$setup,$statement,'ROLLBACK;') -join [Environment]::NewLine
 if ($statement -like 'CREATE DATABASE*') {$sql=('\set VERBOSITY verbose',$statement) -join [Environment]::NewLine}
 $out=$sql | & $psql -X -w -a -h localhost -U $account -d $db -v ON_ERROR_STOP=1 2>&1 | Out-String
 $code=$LASTEXITCODE
 Remove-Item Env:PGPASSWORD
 $denied=$out -match '42501|permission denied|pg_hba.conf rejects connection'
 $passed=if ($allowed) {$code -eq 0} else {$code -ne 0 -and $denied}
 $number=$results.Count+1
 $out | Set-Content "$evidence\sql-$number.txt"
 $results.Add([pscustomobject]@{id=$number;account=$account;database=$db;test=$label;statement=$statement;expected=$(if($allowed){'Allowed'}else{'Denied'});actual=$(if($code -eq 0){'Allowed'}elseif($denied){'Denied'}else{'Other error'});passed=$passed;evidence="evidence/sql-$number.txt"})
}
foreach ($t in 'role','user_account','venue','participant','event','event_schedule','event_assignment','attendance','audit_log') { Test-Sql event_app app "Read $t" "SELECT count(*) FROM $t;" }
Test-Sql event_app app 'Insert into 8 tables using generated sequences' $fixture
foreach ($t in 'venue','participant','event','event_schedule','event_assignment','attendance','user_account') {
 $col=@{venue='location';participant='first_name';event='description';event_schedule='activity_name';event_assignment='staff_name';attendance='attendance_status';user_account='first_name'}[$t]
 $value=if($t -eq 'attendance'){'Late'}else{'Updated'}
 $where=@{venue="venue_name='activity4-permission-probe'";participant="student_number='activity4-probe'";event="event_name='activity4-probe'";event_schedule="activity_name='Probe'";event_assignment="staff_name='Probe'";attendance="participant_id=(SELECT participant_id FROM participant WHERE student_number='activity4-probe')";user_account="username='activity4-probe'"}[$t]
 Test-Sql event_app app "Update $t" "UPDATE $t SET $col='$value' WHERE $where;" $true 'grp02_event_management_db' $fixture
}
$cleanup="DELETE FROM attendance WHERE participant_id=(SELECT participant_id FROM participant WHERE student_number='activity4-probe');"
foreach($t in 'attendance','event_schedule','event_assignment','event','participant','venue') {
 $where=@{attendance="participant_id=(SELECT participant_id FROM participant WHERE student_number='activity4-probe')";event_schedule="activity_name='Probe'";event_assignment="staff_name='Probe'";event="event_name='activity4-probe'";participant="student_number='activity4-probe'";venue="venue_name='activity4-permission-probe'"}[$t]
 $prefix=if($t -in 'event','participant','venue'){$cleanup}else{''}
 if($t -eq 'venue'){$prefix+="DELETE FROM event WHERE event_name='activity4-probe';"}
 Test-Sql event_app app "Delete $t" "$prefix DELETE FROM $t WHERE $where;" $true 'grp02_event_management_db' $fixture
}
foreach($statement in 'CREATE TABLE school_event_management_db.activity4_probe(id int);','ALTER TABLE school_event_management_db.venue ADD COLUMN activity4_probe int;','DROP TABLE school_event_management_db.venue;','TRUNCATE school_event_management_db.audit_log;','UPDATE school_event_management_db.audit_log SET action_performed=''Updated'';','DELETE FROM school_event_management_db.audit_log;','INSERT INTO school_event_management_db.role(role_name) VALUES (''probe'');','DELETE FROM school_event_management_db.user_account;','SELECT * FROM school_event_management_db.flyway_schema_history;','CREATE DATABASE grp02_permission_probe;') { Test-Sql event_app app 'Runtime prohibited operation' $statement $false }
foreach($t in 'role','venue','event') {Test-Sql grp02_readonly readonly "Readonly SELECT $t" "SELECT count(*) FROM $t;"}
foreach($statement in 'INSERT INTO venue(venue_name,location) VALUES (''probe'',''probe'');','UPDATE venue SET location=''probe'';','DELETE FROM venue;','SELECT * FROM user_account;','CREATE TABLE school_event_management_db.activity4_probe(id int);','CREATE DATABASE grp02_permission_probe;') {Test-Sql grp02_readonly readonly 'Readonly prohibited operation' $statement $false}
Test-Sql event_owner owner 'Migration owner create alter drop' 'CREATE TABLE activity4_owner_probe(id int); ALTER TABLE activity4_owner_probe ADD COLUMN note text; DROP TABLE activity4_owner_probe;'
foreach($a in @(@('event_app','app'),@('event_owner','owner'),@('grp02_readonly','readonly'))) {
 foreach($db in 'dropboxed_db','group3_Pawpaw','grp99_gymdb') {Test-Sql $a[0] $a[1] 'Unrelated database connect denied' 'SELECT current_user;' $false $db}
}
$results | ConvertTo-Json -Depth 4 | Set-Content "$evidence\permission-results.json"
$results | Export-Csv "$evidence\permission-results.csv" -NoTypeInformation
$results | Group-Object passed | Select-Object Name,Count
$results | Where-Object {-not $_.passed} | Format-Table



