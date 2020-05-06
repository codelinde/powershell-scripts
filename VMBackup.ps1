# Get hostname
$Hostname = hostname

# Get current date
$Date = Get-Date -Format dd-MMMM-yyyy_HH-mm

# Set backup path
$BackupPath = New-Item "T:\HyperVBackup\HyperV_Export_$Date" -ItemType directory -Force

# Set backup parent path
$BackupParent = "T:\HyperVBackup"

# Set maximum age of backups
$DelDate = (Get-Date).AddDays(-6)

# Delete old backup files
Get-ChildItem $BackupParent -Recurse | Where-Object {$_.LastWriteTime -lt $DelDate} | Remove-Item -Recurse

# Select running VMs
$VMs = Get-VM -ComputerName $Hostname | Where-Object {$_.State -eq "Running"}

# Export selected VMs
Export-VM $VMs -Path $BackupPath

$ExportedVMs = $VMs | Select-Object Name | Out-String

# Get result
if(-not $?) {
    $Result = "Failure"
    Write-EventLog -LogName Application -Source "Backup HyperV" -EntryType Warning -EventId 2 -Message "Hyper-V VMs Export $Result. Exported VMs: $ExportedVMs"
} else {
    $Result = "Success"
    Write-EventLog -LogName Application -Source "Backup HyperV" -EntryType Information -EventId 1 -Message "Hyper-V VMs Export $Result. Exported VMs: $ExportedVMs "
} 

# Variables cleanup
Remove-Variable -Name * -ErrorAction SilentlyContinue