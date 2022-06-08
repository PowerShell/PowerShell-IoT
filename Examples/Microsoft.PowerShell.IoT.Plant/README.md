# Example module Microsoft.PowerShell.IoT.Plant

This PowerShell module is for automating taking care of potted indoor plants.

This module allows a PowerShell script to control lights and water a plant when needed based on soil moisture level.

This showcases GPIO functionality of [the Microsoft.PowerShell.IoT module](../../README.md).

## Hardware setup

Hardware pieces:

* For lights:
  * Desktop lamp
  * [Plant-specific light bulb](https://www.amazon.com/dp/B07567BPVH/ref=sspa_dk_detail_5?psc=1&pd_rd_i=B07567BPVH&pd_rd_wg=5iTv6&pd_rd_r=WYCAF6212XNJ9NQ14E5Q&pd_rd_w=2u0Gj)
  * [Power relay for power mains (for the lamp)](https://www.amazon.com/POWERSWITCHTAIL-COM-PowerSwitch-Tail-II/dp/B00B888VHM/ref=sr_1_1?ie=UTF8&qid=1518818881&sr=8-1)
* For watering:
  * [Small water pump](https://www.adafruit.com/product/1150)
  * [Power Relay for 12V DC](https://www.ebay.com/itm/5V-2-Channel-Relay-Module-Shield-For-Arduino-PIC-ARM-DSP-AVR-Electronic-US/162876526032)
  * [12V DC PowerAdapter (for water pump)](https://www.adafruit.com/product/798)
  * [Soil moisture sensor](https://www.ebay.com/i/122408308563?chn=ps)

Default pin configuration of Microsoft.PowerShell.IoT.Plant module:

* Water pump relay connected to GPIO pin 0.
* Light relay connected to GPIO pin 2.
* Soil moisture sensor sends data to GPIO pin 5.

Wiring diagram will be published shortly.

## Software setup

### Install PowerShell Core on Raspberry Pi

Installation instructions can be found [here](https://github.com/MicrosoftDocs/PowerShell-Docs/blob/d5263484cf6f29148b6e07c7b3e1d9376a5fd635/reference/docs-conceptual/install/install-raspbian.md#raspberry-pi-os).

### Start Powershell and install modules

```powershell
sudo pwsh
Install-Module -Name Microsoft.PowerShell.IoT
git clone https://github.com/PowerShell/PowerShell-IoT.git
Import-Module ./PowerShell-IoT/Examples/Microsoft.PowerShell.IoT.Plant
```

### Manual operation

```powershell
PS /home/pi> # working with light
PS /home/pi> Set-Light On
PS /home/pi> Set-Light Off
PS /home/pi>
PS /home/pi> # working with water
PS /home/pi> Start-Water
PS /home/pi> Stop-Water
PS /home/pi>
PS /home/pi> # reading soil moisture level
PS /home/pi> Read-SoilIsDry
```

### Automated operation

See `full-plant-demo.ps1`.

This script runs 2 PS jobs - one controls light, the other - water.

For demo purposes script runs for 2 minutes. Adjust timeouts in the script for your scenario.
