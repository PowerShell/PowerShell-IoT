# PowerShell-IoT

[![Build status](https://ci.appveyor.com/api/projects/status/ipvxu77rxb5ou8gb?svg=true)](https://ci.appveyor.com/project/PowerShell/powershell-iot)
[![Travis](https://img.shields.io/travis/rust-lang/rust.svg?logo=travis)](https://travis-ci.com/PowerShell/PowerShell-IoT)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/Microsoft.PowerShell.IoT.svg)](https://www.powershellgallery.com/packages/Microsoft.PowerShell.IoT/)

> Note: PowerShell IoT is still in Preview

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
> Set-GpioPin -Id 4 -Value High # You use this to make that^ / we make this cmdlet
> # Our code that makes that^
```

To see some examples of modules built on top of PowerShell IoT, see the [Examples folder](/Examples).

### Supported platforms

#### Supported devices

* Raspberry Pi 3
* Raspberry Pi 2

#### Supported operating systems

* Raspbian Stretch

### Documentation & Examples

Please see our [docs folder here](/docs) for an API reference, pin layout and other docs. For examples, checkout our [examples folder](/Examples).

### Dependencies

This project relies on [RaspberryIO](https://github.com/unosquare/raspberryio).
It's an easy-to-use .NET library for interacting with Raspberry Pi's IO functionality.
RaspberryIO is built on [Wiring Pi](http://wiringpi.com/) -
a pin based GPIO access library written in C.

## Installation

### PowerShell Gallery

You can grab the latest version of PowerShell IoT by running:

```powershell
Install-Module Microsoft.PowerShell.IoT
```

Please note that since this module works with Hardware, higher privileges are required (run PowerShell with `sudo`, or as `root` user) 

Then see the section on [running](#running).

If you want to write a module that uses PowerShell IoT, include it in the `RequiredModules` field of your module manifest.

### GitHub releases

You can also manually download the zipped up module from the [releases](https://github.com/PowerShell/PowerShell-IoT/releases).

Then see the section on [running](#running).

### AppVeyor

You can download the latest CI build from our [AppVeyor build here](https://ci.appveyor.com/project/PowerShell/powershell-iot).
Go to the latest build, click on either of the images, then click on the artifacts tab.
From there, you can download a zip of the latest CI build.

Then see the section on [running](#running).

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

First, you must run pwsh with sudo:

```powershell
sudo pwsh
```

If you have the `Microsoft.PowerShell.IoT` module in your PSModulePath:

```powershell
Import-Module Microsoft.PowerShell.IoT
```

Alternatively, just import the `.psd1`:

```powershell
Import-Module /path/to/Microsoft.PowerShell.IoT/Microsoft.PowerShell.IoT.psd1
```
Hint: PowerShell modules installed with higher previleges are located on `/usr/local/share/powershell/Modules/` , so the path will be something like `/usr/local/share/powershell/Modules/Microsoft.PowerShell.IoT/_currentVersion_`

At this point you can now mess with the module:

```powershell
Get-Command -Module Microsoft.PowerShell.IoT
Get-GpioPin 2 # gets the data from GPIO pin 2
```

#### Testing

You can run tests, but they require a particular setup. Here is how you run them:

```powershell
./build.ps1 -Test
```

The setup required:

* For I2C: An [Adafruit BME280 I2C or SPI Temperature Humidity Pressure Sensor](https://www.adafruit.com/product/2652)
* For GPIO: Bend pins 26 and 22 to touch each other or connect them in some way
* For SPI:  An [Adafruit LIS3DH Triple-Axis Accelerometer](https://www.adafruit.com/product/2809)

We currently have a build agent that will deploy PR code onto a test Raspberry Pi and run the tests found in the `test` directory.
