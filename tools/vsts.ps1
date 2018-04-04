Push-Location "$PSScriptRoot/../"

Install-Module InvokeBuild -Scope CurrentUser -Force

# Build and package for Pi
Invoke-Build

# Move build to Pi
./Move-PSIoTBuild.ps1 -Ip raspberry -WithExample Microsoft.PowerShell.IoT.BME280

# Run Pester tests
Push-Location "test"
Invoke-Build Test

Pop-Location
Pop-Location
