function Enable-Fan
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int] $Pin
    )
    
    Set-GpioPin -Id $Pin -Value High
}

function Disable-Fan
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int] $Pin
    )
    
    Set-GpioPin -Id $Pin -Value Low
}
