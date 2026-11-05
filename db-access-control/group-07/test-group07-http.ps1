param([Parameter(Mandatory=$true)][string]$CredentialFile)
$ErrorActionPreference='Stop'
$base='http://127.0.0.1:8007/index.php'
$web=New-Object Microsoft.PowerShell.Commands.WebRequestSession
$results=[Collections.Generic.List[object]]::new()
foreach($page in 'dashboard','applicants','applications','positions','departments','requirements','interviews','status','applicant_form','department_form','position_form','requirement_form','application_form','interview_form','applicant_requirements'){
 $r=Invoke-WebRequest "${base}?page=$page" -WebSession $web -SkipHttpErrorCheck
 $results.Add([pscustomobject]@{test="GET $page";status=$r.StatusCode;passed=($r.StatusCode -eq 200)})
}
$r=Invoke-WebRequest "${base}?page=department_form" -WebSession $web
$token=[regex]::Match($r.Content,'name="_csrf" value="([^"]+)"').Groups[1].Value
foreach($op in @(
 @{action='department_save';department_name='Activity4 Test Department';description='temporary'},
 @{action='department_save';department_name='Activity4 Test Department';description='duplicate'},
 @{action='department_save';department_name='';description='invalid'}
)){
 $op._csrf=$token
 $r=Invoke-WebRequest $base -Method Post -WebSession $web -Body $op -SkipHttpErrorCheck
 $results.Add([pscustomobject]@{test="POST department "+$op.department_name;status=$r.StatusCode;passed=($r.StatusCode -eq 200);message=([regex]::Matches($r.Content,'Department created successfully|already exists|Department name is required') | ForEach-Object Value) -join ', '})
}
$r=Invoke-WebRequest $base -Method Post -WebSession $web -Body @{action='department_save';department_name='No CSRF'} -SkipHttpErrorCheck
$results.Add([pscustomobject]@{test='POST without CSRF';status=$r.StatusCode;passed=($r.StatusCode -eq 419)})
$s=Import-Clixml $CredentialFile
$env:PGPASSWORD=[Net.NetworkCredential]::new('',$s.app).Password
$id=(& 'E:\DATABASE\PostgreSQL\18\bin\psql.exe' -X -w -h localhost -U grp07_app -d grp07_applicantdb -At -c "SELECT department_id FROM department WHERE department_name='Activity4 Test Department';").Trim()
if($id -notmatch '^\d+$'){throw 'Test department missing'}
foreach($op in @(@{action='department_save';department_id=$id;department_name='Activity4 Updated Department';description='updated'},@{action='department_delete';department_id=$id})){
 $op._csrf=$token
 $r=Invoke-WebRequest $base -Method Post -WebSession $web -Body $op -SkipHttpErrorCheck
 $results.Add([pscustomobject]@{test=$op.action;status=$r.StatusCode;passed=($r.StatusCode -eq 200);message=([regex]::Matches($r.Content,'Department updated successfully|Department deleted successfully') | ForEach-Object Value) -join ', '})
}
Remove-Item Env:PGPASSWORD
$results | ConvertTo-Json -Depth 4 | Set-Content "$PSScriptRoot\evidence\group07-http-results.json"
$results | Format-Table



