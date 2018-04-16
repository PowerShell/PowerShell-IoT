function Set-Led
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName="Pin")]
        [ValidateNotNullOrEmpty()]
        [string] $Pin,

        [Parameter(Mandatory=$true, Position=1, ValueFromPipelineByPropertyName="State")]
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

    Set-GpioPin -Id $Pin -Value $value
}