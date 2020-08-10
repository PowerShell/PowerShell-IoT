# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

function NeedsRestore($rootPath) {
    # This checks to see if the number of folders under a given
    # path (like "src" or "test") is greater than the number of
    # obj\project.assets.json files found under that path, implying
    # that those folders have not yet been restored.
    $projectAssets = (Get-ChildItem "$rootPath\*\obj\project.assets.json")
    return ($projectAssets -eq $null) -or ((Get-ChildItem $rootPath).Length -gt $projectAssets.Length)
}

task Restore -If { "Restore" -in $BuildTask -or (NeedsRestore(".\src")) } {
    Push-Location $PSScriptRoot\src
    exec { dotnet restore }
    Pop-Location
}

task Clean Restore, {
    Push-Location $PSScriptRoot\src
    exec { dotnet clean }
    Pop-Location
}

task Build Restore, {
    Push-Location $PSScriptRoot\src
    exec { dotnet build }
    Pop-Location
}

task Test {
    Install-Module Pester -Force -Scope CurrentUser
    Push-Location $PSScriptRoot\test
    $res = Invoke-Pester -OutputFormat NUnitXml -OutputFile TestsResults.xml -PassThru
    if ($env:APPVEYOR) {
        (New-Object System.Net.WebClient).UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path .\TestsResults.xml));
    }
    if ($res.FailedCount -gt 0) { throw "$($res.FailedCount) tests failed."}
    Pop-Location
}

task Package Clean, Build, {
    if ((Test-Path "$PSScriptRoot\out")) {
        Remove-Item -Path $PSScriptRoot\out -Recurse -Force
    }

    Push-Location "$PSScriptRoot\src\Microsoft.PowerShell.IoT"
    dotnet publish
    Pop-Location

    New-Item -ItemType directory -Path $PSScriptRoot\out
    New-Item -ItemType directory -Path $PSScriptRoot\out\Microsoft.PowerShell.IoT

    Copy-Item -Path "$PSScriptRoot\src\Microsoft.PowerShell.IoT\Microsoft.PowerShell.IoT.psd1" -Destination "$PSScriptRoot\out\Microsoft.PowerShell.IoT\" -Force
    Copy-Item -Path "$PSScriptRoot\src\Microsoft.PowerShell.IoT\bin\Debug\netcoreapp2.0\publish\*" -Destination "$PSScriptRoot\out\Microsoft.PowerShell.IoT\" -Force -Recurse

    if ($env:TF_BUILD) {
        Import-Module "$PSScriptRoot\tools\vstsBuild.psm1"
        Publish-VstsBuildArtifact -ArtifactPath "$PSScriptRoot\out\Microsoft.PowerShell.IoT" -Bucket "Microsoft.PowerShell.IoT"
    }
}

# The default task is to run the entire CI build
task . Package
