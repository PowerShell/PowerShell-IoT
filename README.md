# PowerShell-IoT

Docs will change...

## Getting Started

### Prereqs

* [PowerShell Core 6 or greater](https://github.com/PowerShell/PowerShell/releases)
* [.NET Core SDK 2.0 or greater](https://www.microsoft.com/net/download/)
* [InvokeBuild](https://www.powershellgallery.com/packages/InvokeBuild/)

### Building

1. Clone/download the repo
2. run `./build.ps1 -Bootstrap` to see if you're missing any tooling
3. run `./build.ps1` to build

At this point you can import the built module and mess with it:

```powershell
Import-Module ./src/psiot/bin/Debug/netcoreapp2.0/PSIoT.psd1
Get-GpioPin 2
```

You can package the build up by using Invoke-Build:

```powershell
Invoke-Build Package
```

You can run tests, but they don't do anything right now:

```powershell
./build.ps1 -Test
```