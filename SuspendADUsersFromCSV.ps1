Set-ExecutionPolicy unrestricted
Import-Module ActiveDirectory

$csvPath = "YOUR PATH HERE"

Start-Transcript -Path "YOUR PATH HERE\Logs\transcript$(Get-Date -f yyyyMMdd).txt"

try {
	Write-Host 'Reading the CSV file......'
	$userList = Import-Csv $csvPath
} catch {
	Write-Error "CSV import failed"
	Exit
}	

foreach ($user in $userList) {
	try { 
        $samaccountname = $user.samaccountname
        
        Write-Host "Suspending User: $samaccountname"
        
        Get-ADUser $samaccountname | Disable-ADAccount -PassThru | Move-ADObject -TargetPath 'OU=YOUR,OU=OU,DC=YOUR,DC=DOMAIN'

    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{
        Write-Host "Account not found: $samaccountname"
        Write-Host "Moving on to the next user..."
        }
}

Write-Host "Process Complete"