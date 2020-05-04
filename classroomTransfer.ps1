$oldteacher = Read-Host 'I want to transfer classes from (enter teacher e-mail)'
$newteacher = Read-Host 'I want to transfer classes to (enter teacher-email)'

$confirmation = Read-Host "You will now transfer courses from $oldteacher to $newteacher. Are you sure you want to continue? This operation cannot be undone. [y/n]"
while($confirmation -ne "y")
{
    if ($confirmation -eq 'n') {exit}
    $confirmation = Read-Host "You will now transfer courses from $oldteacher to $newteacher. Are you sure you want to continue? This operation cannot be undone. [y/n]"
}

Write-Output "Now transferring courses from $oldteacher to $newteacher."

gam print courses teacher $oldteacher | gam csv - gam course ~id add teacher $newteacher
gam print courses teacher $oldteacher | gam csv - gam update course ~id owner $newteacher
# this part of the API seems to be hit or miss
gam print courses teacher $oldteacher | gam csv - gam course ~id remove teacher $newteacher

Write-Output "Operation complete!"
Read-Host "Press ENTER to exit"