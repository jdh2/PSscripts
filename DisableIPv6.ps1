$ErrorActionPreference = "SilentlyContinue"
$logfolder = "$env:programdata\DisableIPv6"
$logfile = "$logfolder\DisableIPv6.log"
$regvalue = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\DisableComponents"

#Check if the logfolder directory exists, if not create it
if (!(Test-Path -Path $logfolder)) {
    New-Item -Path $logfolder -ItemType Directory -Force
}

#Check if the logfile already exists and execute code if it does not
if (!(Test-Path -Path $logfile)) {

    #Check if the DisabledComponents registry value exists, if it does not, create it and create a log file
    if (!(Test-Path -path $regvalue)) {
        New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" -Name DisabledComponents -Value 255 -PropertyType DWord
        New-Item -ItemType File -Path $logfile
        
    }

}
