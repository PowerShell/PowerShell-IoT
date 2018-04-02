Push-Location "$PSScriptRoot/../"

# Build and package for Pi
Invoke-Build

# Move build to Pi
./Move-PSIoTBuild.ps1 -Ip raspberry

# Run Pester tests
Push-Location "test"
Invoke-Build Test

Pop-Location
Pop-Location