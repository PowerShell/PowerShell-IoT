# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

function NeedsRestore($rootPath) {
    # This checks to see if the number of folders under a given
    # path (like "src" or "test") is greater than the number of
    # obj\project.assets.json files found under that path, implying
    # that those folders have not yet been restored.
    $projectAssets = (Get-ChildItem "$rootPath\*\obj\project.assets.json")
    return ($projectAssets -eq $null) -or ((Get-ChildItem $rootPath).Length -gt $projectAssets.Length)
}

task SetupDotNet -Before Clean, Build, Package {

    $requiredSdkVersion = "2.0.0"

    $dotnetPath = "$PSScriptRoot/.dotnet"
    $dotnetExePath = if ($script:IsUnix) { "$dotnetPath/dotnet" } else { "$dotnetPath/dotnet.exe" }
    $originalDotNetExePath = $dotnetExePath

    if (!(Test-Path $dotnetExePath)) {
        $installedDotnet = Get-Command dotnet -ErrorAction Ignore
        if ($installedDotnet) {
            $dotnetExePath = $installedDotnet.Source
        }
        else {
            $dotnetExePath = $null
        }
    }

    # Make sure the dotnet we found is the right version
    if ($dotnetExePath) {
        # dotnet --version can return a semver that System.Version can't handle
        # e.g.: 2.1.300-preview-01. The replace operator is used to remove any build suffix.
        $version = (& $dotnetExePath --version) -replace '[+-].*$',''
        if ([version]$version -ge [version]$requiredSdkVersion) {
            $script:dotnetExe = $dotnetExePath
        }
        else {
            # Clear the path so that we invoke installation
            $script:dotnetExe = $null
        }
    }
    else {
        # Clear the path so that we invoke installation
        $script:dotnetExe = $null
    }

    if ($script:dotnetExe -eq $null) {

        Write-Host "`n### Installing .NET CLI $requiredSdkVersion...`n" -ForegroundColor Green

        # The install script is platform-specific
        $installScriptExt = if ($script:IsUnix) { "sh" } else { "ps1" }

        # Download the official installation script and run it
        $installScriptPath = "$([System.IO.Path]::GetTempPath())dotnet-install.$installScriptExt"
        Invoke-WebRequest "https://raw.githubusercontent.com/dotnet/cli/v2.0.0/scripts/obtain/dotnet-install.$installScriptExt" -OutFile $installScriptPath
        $env:DOTNET_INSTALL_DIR = "$PSScriptRoot/.dotnet"

        if (!$script:IsUnix) {
            & $installScriptPath -Version $requiredSdkVersion -InstallDir "$env:DOTNET_INSTALL_DIR"
        }
        else {
            & /bin/bash $installScriptPath -Version $requiredSdkVersion -InstallDir "$env:DOTNET_INSTALL_DIR"
            $env:PATH = $dotnetExeDir + [System.IO.Path]::PathSeparator + $env:PATH
        }

        Write-Host "`n### Installation complete." -ForegroundColor Green
        $script:dotnetExe = $originalDotnetExePath
    }

    # This variable is used internally by 'dotnet' to know where it's installed
    $script:dotnetExe = Resolve-Path $script:dotnetExe
    if (!$env:DOTNET_INSTALL_DIR)
    {
        $dotnetExeDir = [System.IO.Path]::GetDirectoryName($script:dotnetExe)
        $env:PATH = $dotnetExeDir + [System.IO.Path]::PathSeparator + $env:PATH
        $env:DOTNET_INSTALL_DIR = $dotnetExeDir
    }

    Write-Host "`n### Using dotnet v$(& $script:dotnetExe --version) at path $script:dotnetExe`n" -ForegroundColor Green
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
    $res = Invoke-Pester -OutputFormat NUnitXml -OutputFile TestsResults.xml -PassThru;
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
}

# The default task is to run the entire CI build
task . Package
