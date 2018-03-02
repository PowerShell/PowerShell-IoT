param (
    [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Ip,

    [Parameter()]
    [string[]]
    $WithExample,

    [Parameter()]
    [switch]
    $Build
)
begin {
    $sessions = @()
}

process {
    Write-Host "Connecting to $_"
    $sessions += New-PSSession -HostName $_ -UserName pi
}

end {
    if ($Build) {
        Invoke-Build
    }

    $sessions | ForEach-Object {
        $session = $_

        # Should compress and decompress
        Copy-Item "$PSScriptRoot\out\PSIoT" "/usr/local/share/powershell/Modules/PSIoT" -Recurse -Force -ToSession $session

        if ($WithExample) {
            $WithExample | ForEach-Object {
                $path = "$PSScriptRoot\Examples\$_"
                if (Test-Path $path) {
                    # Should compress and decompress
                    Copy-Item $path "/usr/local/share/powershell/Modules" -Recurse -Force -ToSession $session
                }
            }
        }
    }
}