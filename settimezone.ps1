<#
    SCRIPT: Set-TimeZoneGeoIP.ps1
    DESCRIPTION: Based on the public egress IP obtain geoLocation details and match to a time zone
                 Once obtained set the Time Zone on the destination computer
#>

<#
    SETUP ATTRIBUTES
#>
$logFile = "$env:ProgramData\Intune-PowerShell-Logs\TimeZoneAPI-" + $(Get-Date).ToFileTimeUtc() + ".log"
Start-Transcript -Path $LogFile -Append


$ipStackAPIKey = "a3ec79306b8ea2e263f7a4f192f9c498" #used to get geoCoordinates of the public IP. get the API key from https://ipstack.com
$bingMapsAPIKey = "AuWMfUDJPlH5zrbbXl4yA0c7GGN_lnU8XdIiXs455p-X8abunxwLcDW8kisWXPBC" #Used to get the Windows TimeZone value of the location coordinates. get teh API key from https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bingmaps.mapapis

<#
    Attempt to get Lat and Long for current IP
#>

Write-Output "Attempting to get coordinates from egress IP address"
try {
    $geoIP = Invoke-RestMethod -Uri "http://api.ipstack.com/check?access_key=$($ipStackAPIKey)" -ErrorAction SilentlyContinue -ErrorVariable $ErrorGeoIP
}
Catch {
    Write-Output "Error obtaining coordinates or public IP address, script will exit"
    Exit
}

Write-Output "Detected that $($geoIP.ip) is located in $($geoIP.country_name) at $($geoIP.latitude),$($geoIP.longitude)"
Write-Output "Attempting to find Corresponding Time Zone"
try {
    $timeZone = Invoke-RestMethod -Uri "https://dev.virtualearth.net/REST/v1/timezone/$($geoIP.latitude),$($geoIP.longitude)?key=$($bingMapsAPIKey)" -ErrorAction Stop -ErrorVariable $ErrortimeZone
}
catch {
    Write-Output "Error obtaining Timezone from Bing Maps API. Script will exit"
    Exit
}
$correctTimeZone = $TimeZone.resourceSets.resources.timeZone.windowsTimeZoneId
$currentTimeZone = $(Get-TimeZone).id
Write-Output "Detected Correct time zone as $($correctTimeZone), current time zone is set to $($currentTimeZone)"
if($correctTimeZone -eq $currentTimeZone) {
    Write-Output "Current time zone value is correct"
}
else {
    Write-Output "Attempting to set timezone to $($correctTimeZone)"
    Set-TimeZone -Id $correctTimeZone -ErrorAction SilentlyContinue -ErrorVariable $ErrorSetTimeZone
    Write-Output "Set Time Zone to: $($(Get-TimeZone).id)"
}

Stop-Transcript