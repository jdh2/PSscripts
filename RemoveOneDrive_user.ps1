#   Description:
# This script will remove and disable OneDrive from the user profile.
$ErrorActionPreference = "SilentlyContinue"
$logfile = "RemoveOneDrive_User.log"
$logfolder = "$env:programdata\RemoveOneDrive\"

if (!(Test-Path -Path $logfolder)) {
    New-Item -Path $logfolder -ItemType Directory -Force
}

Start-Transcript "$logfolder\$logfile" -Append -IncludeInvocationHeader
if (Get-Process -Name OneDrive) {
    Stop-Process -Name OneDrive
}


#Check where OneDriveSetup is located, different for 32bit and 64bit
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}
if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
}

Remove-Item -Recurse -Force "$env:localappdata\Microsoft\OneDrive"

# check if directory is empty before removing:
If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Recurse -Force "$env:userprofile\OneDrive"
}

Remove-Item -Force "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*'| Unregister-ScheduledTask -Confirm:$false
Stop-Transcript