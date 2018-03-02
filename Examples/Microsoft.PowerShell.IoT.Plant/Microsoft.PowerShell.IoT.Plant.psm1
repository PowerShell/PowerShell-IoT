function Read-SoilIsDry
{
    $raw = Get-GpioPin -Id 5 -Raw
    if($raw -eq "High")
    {
        return $true
    }
    else
    {
        return $false
    }
}

function Set-Light
{
    param
    (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateSet('On','Off',ignorecase=$true)]
        [string] $State
    )
    if ($State -eq 'On')
    {
        $value = "High"
    }
    else
    {
        $value = "Low"
    }

    Set-GpioPin -Id 2 -Value $value
}

function Start-Water
{
    Set-GpioPin -Id 0 -Value "Low"
}

function Stop-Water
{
    Set-GpioPin -Id 0 -Value "High"
}