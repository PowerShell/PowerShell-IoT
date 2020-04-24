param
(
    [int] $Pin = 17,
    [int] $OnTemperature = 70,
    [int] $OffTemperature = 50,
    [ValidateSet("Fahrenheit","Celsius")]
    [string]$TemperatureScale = "Celsius",
    [int] $PollPeriodSeconds = 5
)

Import-Module $PSScriptRoot/Microsoft.PowerShell.IoT.Fan.psd1

$OnTemperatureC = $OnTemperature
$OffTemperatureC = $OffTemperature
if ($TemperatureScale -eq "Fahrenheit")
{
    $OnTemperatureC = ($OnTemperature - 32) * 5 / 9
    $OffTemperatureC = ($OffTemperature - 32) * 5 / 9
}

while($true)
{
    $CpuTemperatureC = (Get-Content /sys/class/thermal/thermal_zone0/temp) / 1000
    $CpuTemperatureF = ($CpuTemperatureC * 9 / 5) + 32

    (Get-Date).ToString() + ": CPU temperature  =  $CpuTemperatureC C | $CpuTemperatureF F" | Write-Verbose

    if ($CpuTemperatureC -gt $OnTemperatureC)
    {
        "Starting fan..." | Write-Verbose
        Enable-Fan -Pin $Pin
    }
    elseif ($CpuTemperatureC -lt $OffTemperatureC)
    {
        "Stopping fan..." | Write-Verbose
        Disable-Fan -Pin $Pin
    }
    
    Start-Sleep -Seconds $PollPeriodSeconds
}
