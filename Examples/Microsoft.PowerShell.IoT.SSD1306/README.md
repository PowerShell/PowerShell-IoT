# Example module Microsoft.PowerShell.IoT.SSD1306

This PowerShell module is for working with [small I2C OLED displays](https://www.ebay.com/itm/2X-0-96-I2C-IIC-Serial-128X64-LED-OLED-LCD-Display-Module-for-Arduino-White/191785893008?epid=2001476960&hash=item2ca7547c90:g:WbwAAOSwAPVZLOx~) based on [SSD1306 driver chip](https://cdn-shop.adafruit.com/datasheets/SSD1306.pdf).

## Hardware setup

There are many versions of small OLED displays; in this example we'll use a version based on I2C interface.

Wiring diagram with Raspberry Pi 3 is like this:

zzz

## Software setup

### Install PowerShell Core on Raspberry Pi

Installation instructions can be found [here](https://github.com/PowerShell/PowerShell/tree/master/docs/installation/linux.md#raspbian).

### Enable I2C interface on Raspberry Pi

1. `sudo raspi-config`
2. `5 Interfacing options`
3. `P5 I2C`
4. `Would you like ARM I2C interface to be enabled -> Yes`

### Start Powershell and install modules

```powershell
sudo pwsh
Install-Module -Name Microsoft.PowerShell.IoT
git clone https://github.com/PowerShell/PowerShell-IoT.git
Import-Module ./PowerShell-IoT/Examples/Microsoft.PowerShell.IoT.SSD1306
```

### Run example
```powershell
PS /home/pi> New-OledDisplay | Set-OledText -Value "Hello from PowerShell"
```