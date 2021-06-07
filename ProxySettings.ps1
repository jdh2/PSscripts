$ErrorActionPreference = "SilentlyContinue"
#$logfolder = "$env:programdata\DisableJavaUpdate"
#$logfile = "$logfolder\DisableJavaUpdate.log"
$regpaths = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\","HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\"
$regvalue = "ProxyServer"

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

#Check if the logfolder directory exists, if not create it
#if (!(Test-Path -Path $logfolder)) {
#    New-Item -Path $logfolder -ItemType Directory -Force
#}
$hostname = $env:COMPUTERNAME
foreach ($regpath in $regpaths)
{
    if (Test-RegistryValue -path $regpath -Value $regvalue) {
        $regdata = (Get-ItemProperty -Path $regpath -Name $regvalue).ProxyServer
    } else {
        $regdata = "Empty"
    }
    [PSCustomObject]@{
        ComputerName = $hostname
        RegistryPath = $regpath
        RegistryValue = $regvalue
        RegistryData = $regdata
    } | Export-Csv -NoTypeInformation -Path c:\temp\proxysettings.csv -Append
}


 