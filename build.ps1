# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

#!/usr/bin/env pwsh
param(
    [Parameter()]
    [switch]
    $Bootstrap,

    [Parameter()]
    [switch]
    $Clean,

    [Parameter()]
    [switch]
    $Test
)

$NeededTools = @{
    PowerShellCore = "PowerShell Core 6.0.0 or greater"
    DotNetSdk = "dotnet sdk 2.0 or greater"
    InvokeBuild = "InvokeBuild latest"
}

function needsPowerShellCore () {
    try {
        $powershellverison = (pwsh -v)
    } catch {
        return $true
    }
    return $false
}

function needsDotNetSdk () {
    try {
        $dotnetverison = (dotnet --version)
    } catch {
        return $true
    }
    return $false
}

function needsInvokeBuild () {
    if (Get-Module -ListAvailable -Name InvokeBuild) {
        return $false
    }
    return $true
}

function getMissingTools () {
    $missingTools = @()

    if (needsPowerShellCore) {
        $missingTools += $NeededTools.PowerShellCore
    }
    if (needsDotNetSdk) {
        $missingTools += $NeededTools.DotNetSdk
    }
    if (needsInvokeBuild) {
        $missingTools += $NeededTools.InvokeBuild
    }

    return $missingTools
}

function hasMissingTools () {
    return ((getMissingTools).Count -gt 0)
}

if ($Bootstrap) {
    $string = "Here is what your environment is missing:`n"
    $missingTools = getMissingTools
    if (($missingTools).Count -eq 0) {
        $string += "* nothing!`n`n Run this script without a flag to build or a -Clean to clean."
    } else {
        $missingTools | ForEach-Object {$string += "* $_`n"}
        $string += "`nAll instructions for installing these tools can be found on PowerShell Editor Services' Github:`n" `
            + "https://github.com/powershell/PowerShellEditorServices#development"
    }
    Write-Host "`n$string`n"
} elseif(hasMissingTools) {
    Write-Host "You are missing needed tools. Run './build.ps1 -Bootstrap' to see what they are."
} else {
    if($Clean) {
        Invoke-Build Clean
    }

    Invoke-Build Package

    if($Test) {
        Invoke-Build Test
    }
}