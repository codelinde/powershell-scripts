Set-ExecutionPolicy unrestricted
Import-Module ActiveDirectory

# Generate random password
Add-Type -AssemblyName 'System.Web'
$length = 8
$nonAlphaChars = 1
$password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
$password | Out-File "PATH OF LOCATION TO STORE IN PLAINTEXT VERSION"
# We had the need to then copy the password to a directory that would upload it to the cloud
# Copy-Item "PATH FROM LINE 9" "PATH TO CLOUD LOCATION"

# Set password on AD account
Set-ADAccountPassword -Identity spsubstitute -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force)