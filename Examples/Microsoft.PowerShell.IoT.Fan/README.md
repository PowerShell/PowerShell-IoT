# Example module Microsoft.PowerShell.IoT.Fan

This PowerShell module is for turning on/off a fan on Raspberry Pi 4 case enclosure.
This showcases GPIO functionality of [the Microsoft.PowerShell.IoT module](../../README.md).

## Hardware setup

[This Raspberry Pi 4 case enclosure](https://www.amazon.com/gp/product/B07XTRK8D4) comes with a 5V fan that can be connected to Raspberry Pi 5V and GND pins.
This fan is nice but a little noisy so we can use this example module to turn it off when the CPU temperature is relatively low.
An [IRLB8721 transistor](https://www.adafruit.com/product/355) can be used to switch power to the fan based on GPIO line of Raspberry Pi.

## Wiring

Insert IRLB8721 transistor into the break of the negative wire of the fan.
Connect transistor gate to GPIO 17 (BCM schema) on Raspberry Pi.

![Mossfet1](https://user-images.githubusercontent.com/11860095/79925701-d6a85580-83ef-11ea-894d-93507507df5e.jpg)
![Mossfet2](https://user-images.githubusercontent.com/11860095/79925725-e6c03500-83ef-11ea-9abd-7dd39be69bd1.jpg)

## Software setup

### Install PowerShell Core on Raspberry Pi

Installation instructions can be found [here](https://github.com/PowerShell/PowerShell/tree/master/docs/installation/linux.md#raspbian).

### Start Powershell and install modules

```powershell
pwsh

Install-Module -Name Microsoft.PowerShell.IoT

git clone https://github.com/PowerShell/PowerShell-IoT.git
```

### Usage

```powershell
# Start monitoring CPU temperature and turn on the fan when it reaches 71 degrees; turn fan off when CPU temperature drops below 55 degrees
pwsh ./PowerShell-IoT/Examples/Microsoft.PowerShell.IoT.Fan/SmartFan.ps1 -Pin 17 -OnTemperature 71 -OffTemperature 55 -TemperatureScale Celsius
VERBOSE: 1:36:05 PM: CPU temperature  =  71.575 C | 160.835 F
VERBOSE: Starting fan...
VERBOSE: 1:36:10 PM: CPU temperature  =  70.601 C | 159.0818 F
VERBOSE: 1:36:16 PM: CPU temperature  =  70.114 C | 158.2052 F
VERBOSE: 1:36:21 PM: CPU temperature  =  68.653 C | 155.5754 F
#...
VERBOSE: 1:39:01 PM: CPU temperature  =  55.504 C | 131.9072 F
VERBOSE: 1:39:06 PM: CPU temperature  =  55.504 C | 131.9072 F
VERBOSE: 1:39:11 PM: CPU temperature  =  54.043 C | 129.2774 F
VERBOSE: Stopping fan...
VERBOSE: 1:39:17 PM: CPU temperature  =  55.991 C | 132.7838 F
#...
```

This produces following CPU temperature graph:
![CPU-Temp-graph](https://user-images.githubusercontent.com/11860095/79926138-fbe99380-83f0-11ea-8705-b1336fc7bd7d.png)