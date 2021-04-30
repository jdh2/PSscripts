#This script delete the registry value UpdateToVersion located at HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration
#This registry value was set to a specific Office version and was preventing the Office clients from updating past the version listed
#in the reg value.
$ErrorActionPreference = "SilentlyContinue"
$logfolder = "$env:programdata\Aspen"
$logfile = "$logfolder\RemoveUpdateToVersion.log"
$regpath = "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
$regvalue = "UpdateToVersion"

#Check if the logfolder directory exists, if not create it
if (!(Test-Path -Path $logfolder)) {
    New-Item -Path $logfolder -ItemType Directory -Force
}

#Check if the logfile already exists and execute code if it does not
if (!(Test-Path -Path $logfile)) {

    #Check if the DisabledComponents registry value exists, if it does not, create it and create a log file
    if (!(Test-Path -path "$regpath\$regvalue")) {
        Remove-ItemProperty -Path $regpath -Name $regvalue
        New-Item -ItemType File -Path $logfile
        
    }

}