#   Description:
# This script will remove and disable OneDrive integration.

$ErrorActionPreference = "SilentlyContinue"
$logfile = "RemoveOneDrive_System.log"
$logfolder = "$env:programdata\RemoveOneDrive\"

if (!(Test-Path -Path $logfolder)) {
    New-Item -Path $logfolder -ItemType Directory -Force
}

Start-Transcript "$logfolder\$logfile" -Append -IncludeInvocationHeader
if (Get-Process -Name OneDrive) {
    Stop-Process -Name OneDrive
}

#Write-Output "Remove OneDrive"
#if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
#    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
#}
#if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
#    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
#}
#

Remove-Item -Recurse -Force "$env:programdata\Microsoft OneDrive"


#Write-Output "Remove Onedrive from explorer sidebar"
#New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
#mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
#Set-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
#mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
#Set-ItemProperty -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
#Remove-PSDrive "HKCR"

#Loads the Default user registry and removes the OneDriveSetup value from the Run key to prevent OneDrive from reinstalling
# Thank you Matthew Israelsson
reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
if (Test-RegistryValue -Path "HKEY_USERS:\HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Value OneDriveSetup){
    reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
}
reg unload "hku\Default"

Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' | Unregister-ScheduledTask -Confirm:$false

Stop-Transcript



#Creates the Test-RegistryValue cmdlet
function Test-RegistryValue {

    param (
    
     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$Path,
    
    [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$Value
    )
    
    try {
    
    Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
     return $true
     }
    
    catch {
    
    return $false
    
    }
    
    }