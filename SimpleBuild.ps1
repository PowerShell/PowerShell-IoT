if ((Test-Path "$PSScriptRoot\out")) {
    Remove-Item -Path $PSScriptRoot\out -Recurse -Force
}

Push-Location "$PSScriptRoot\src\Microsoft.PowerShell.IoT"
dotnet publish
Pop-Location

New-Item -ItemType directory -Path $PSScriptRoot\out | Out-Null
New-Item -ItemType directory -Path $PSScriptRoot\out\Microsoft.PowerShell.IoT | Out-Null

$OutModulePath = "$PSScriptRoot\out\Microsoft.PowerShell.IoT"

Copy-Item -Path "$PSScriptRoot\src\Microsoft.PowerShell.IoT\Microsoft.PowerShell.IoT.psd1" -Destination $OutModulePath -Force
Copy-Item -Path "$PSScriptRoot\src\Microsoft.PowerShell.IoT\bin\Debug\netstandard2.0\publish\*" -Destination $OutModulePath -Force -Recurse

"Build module location:   $OutModulePath" | Write-Verbose -Verbose

"Setting VSTS variable 'BuildOutDir' to '$OutModulePath'" | Write-Verbose -Verbose
Write-Host "##vso[task.setvariable variable=BuildOutDir]$OutModulePath"
