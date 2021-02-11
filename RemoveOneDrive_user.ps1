#   Description:
# This script will remove and disable OneDrive from the user profile.

$ErrorActionPreference = SilentlyContinue
Start-Transcript "$env:localappdata\Microsoft\removeonedrive_user.log" -Append -IncludeInvocationHeader
Write-Output "Kill OneDrive process"
taskkill.exe /F /IM "OneDrive.exe"

Write-Output "Remove OneDrive"
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}
if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
}

Write-Output "Removing OneDrive leftovers"
Remove-Item -Recurse -Force "$env:localappdata\Microsoft\OneDrive" -ErrorAction Ignore

# check if directory is empty before removing:
If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Recurse -Force "$env:userprofile\OneDrive" -ErrorAction Ignore
}


Write-Output "Removing startmenu entry"
Remove-Item -Force "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -ErrorAction Ignore

Write-Output "Removing scheduled task"
Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ErrorAction Ignore | Unregister-ScheduledTask -Confirm:$false -ErrorAction Ignore
Stop-Transcript