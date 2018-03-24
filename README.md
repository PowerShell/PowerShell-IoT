# PowerShell-IoT

[![Build status](https://ci.appveyor.com/api/projects/status/ipvxu77rxb5ou8gb?svg=true)](https://ci.appveyor.com/project/PowerShell/powershell-iot)
[![Travis](https://img.shields.io/travis/rust-lang/rust.svg?logo=travis)](https://travis-ci.com/PowerShell/PowerShell-IoT)

A PowerShell module for interacting with hardware sensors and devices using common protocols: GPIO, I2C & SPI.

![An SSD1306 displaying "Hello World from PowerShell"](https://pbs.twimg.com/media/DV8c8Y3V4Ac7PaH.jpg:small)

## Information

### Goals

The main goal of this project is to provide a friendly interface for interacting with hardware sensors and devices using PowerShell.

That said,
it was built as close to the metal as possible to keep the library broad enough to cover a range of sensors and devices.

The hope is that this module will be the foundation for other modules that will expose specific cmdlets for interacting with specific sensors and devices.

For example, a cmdlet stack to turn on a light bulb might be:

```powershell
> Set-Light On # Your user types this / you make this cmdlet
> Set-GpioPin -Pin 4 # You use this to make that^ / we make this cmdlet
> # Our code that makes that^
```

To see some examples of modules built on top of PowerShell IoT, see the [modules folder](/modules).

### Dependencies

This project relies on [RaspberryIO](https://github.com/unosquare/raspberryio).
It's an easy-to-use .NET library for interacting with Raspberry Pi's IO functionality.
RaspberryIO is built on [Wiring Pi](http://wiringpi.com/) -
a pin based GPIO access library written in C.

### Supported devices

* Raspberry Pi 3

### Supported operating systems

* Raspbian Trusty

## Installation

### PowerShell Gallery

_Installation from the PowerShell Gallery coming soon._

### From Source

#### Prerequisites

* [PowerShell Core 6 or greater](https://github.com/PowerShell/PowerShell/releases)
* [.NET Core SDK 2.0 or greater](https://www.microsoft.com/net/download/)
* [InvokeBuild](https://www.powershellgallery.com/packages/InvokeBuild/)
* A supported device like a [Raspberry Pi 3](https://www.raspberrypi.org/) with [PowerShell Core 6 on it](https://github.com/powershell/powershell#get-powershell)

#### Building

_NOTE: You can't build on ARM devices at this time so you will need to build on another machine and copy the build to the device._

1. Clone/download the repo
2. run `./build.ps1 -Bootstrap` to see if you're missing any tooling
3. run `./build.ps1` to build

At this point, you'll notice an `out` folder has been generated in the root of your repo.
The project is ready to be deployed to your device.

#### Deploying

We have included a helper script, `Move-PSIoTBuild.ps1`,
that will move the PowerShell IoT build over to your device.
This copy uses PSRP over SSH so make sure you're able to connect to your pi this way.
The `Microsoft.PowerShell.IoT` module will be copied to your `$env:PSModulePath` on your device.
Here's an example:

```powershell
Move-PSIoTBuild.ps1 -Ip 10.123.123.123 # IP address of device
```

You can also easily copy examples in the `Examples` folder over using the `-WithExample` flag.
Just give a list of examples you want to copy over and it will move those to you `$env:PSModulePath` along with `Microsoft.PowerShell.IoT`:

```powershell
Move-PSIoTBuild.ps1 -Ip 10.123.123.123 -WithExample Microsoft.PowerShell.IoT.Plant,Microsoft.PowerShell.IoT.SSD1306
```

Also, with the `-Build` parameter,
it will build/test/package your project before moving it.

_NOTE: If you'd rather not use the script, simply copy the `out/Microsoft.PowerShell.IoT` to your device to get started._

#### Running

If you have the `Microsoft.PowerShell.IoT` module in your PSModulePath:

```powershell
Import-Module Microsoft.PowerShell.IoT
```

Alternatively, just import the `.psd1`:

```powershell
Import-Module /path/to/Microsoft.PowerShell.IoT/Microsoft.PowerShell.IoT.psd1
```

At this point you can now mess with the module:

```powershell
Get-Command -Module Microsoft.PowerShell.IoT
Get-GpioPin 2 # gets the data from GPIO pin 2
```

#### Testing

You can run tests,
but they don't do anything right now:

```powershell
./build.ps1 -Test
```

We will investigate standing up a test rig of supported devices and OS's so that we can test against actual hardware.