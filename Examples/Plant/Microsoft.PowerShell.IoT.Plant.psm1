function SoilIsDry
{
    Get-GpioPin -Pin 5
}

function Set-Lights
{
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [bool] $Value
    )
    
    Set-GpioPin -Pin 2 -Value $Value
}

function Set-Water
{
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [bool] $Value
    )
    
    Set-GpioPin -Pin 0 -Value (-not $Value)
}
