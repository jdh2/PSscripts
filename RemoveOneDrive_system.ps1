#   Description:
# This script will remove and disable OneDrive integration.

$ErrorActionPreference = SilentlyContinue

Start-Transcript "$env:programdata\Microsoft\removeonedrive_system.log" -Append
Stop-Process -Name OneDrive -ErrorAction Ignore

#Write-Output "Remove OneDrive"
#if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
#    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
#}
#if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
#    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
#}
#
Write-Output "Removing OneDrive leftovers"
Remove-Item -Recurse -Force "$env:programdata\Microsoft OneDrive" -ErrorAction Ignore


#Write-Output "Remove Onedrive from explorer sidebar"
#New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
#mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
#Set-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
#mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
#Set-ItemProperty -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
#Remove-PSDrive "HKCR"

# Thank you Matthew Israelsson
Write-Output "Removing run hook for new users"
reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
reg unload "hku\Default"

Write-Output "Removing scheduled task"
Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ErrorAction Ignore | Unregister-ScheduledTask -Confirm:$false -ErrorAction Ignore

Stop-Transcript