function Read-SoilIsDry
{
    Get-GpioPin -Pin 5
}

function Set-Light
{
    param
    (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateSet('On','Off',ignorecase=$true)]
        [string] $State
    )
    [bool]$value = $State -eq 'On'
    Set-GpioPin -Pin 2 -Value $value
}

function Start-Water
{
    Set-GpioPin -Pin 0 -Value $false
}

function Stop-Water
{
    Set-GpioPin -Pin 0 -Value $true
}