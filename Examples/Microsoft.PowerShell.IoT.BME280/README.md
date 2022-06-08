# Example module Microsoft.PowerShell.IoT.BME280

This PowerShell module is for interacting with [BME280 environmental sensor](https://www.bosch-sensortec.com/bst/products/all_products/bme280) for reading temperature, pressure and humidity.

## Hardware setup

Several vendors have breakout boards with BME280 sensor. In this example we'll use [BME280 breakout board from Adafruit](https://www.adafruit.com/product/2652).

BME280 sensor supports both I2C and SPI interfaces; in this example we'll use I2C.

Later, in the software section, we'll need to use I2C address of the BME280 sensor.
The default I2C address is 0x77. It can be changed to 0x76 by connecting SDO to GND.

Wiring diagram with Raspberry Pi 3 is like this:

![bme280_schema](https://user-images.githubusercontent.com/11860095/38394384-1899c3d4-38e3-11e8-8f8d-a93918971773.png)

## Software setup

### Install PowerShell Core on Raspberry Pi

Installation instructions can be found [here](https://github.com/MicrosoftDocs/PowerShell-Docs/blob/d5263484cf6f29148b6e07c7b3e1d9376a5fd635/reference/docs-conceptual/install/install-raspbian.md#raspberry-pi-os).

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
Import-Module ./PowerShell-IoT/Examples/Microsoft.PowerShell.IoT.BME280
```

### Collect Data
```powershell
PS /home/pi> $device = Get-BME280Device -Id 0x77 # I2C address of the sensor
PS /home/pi> $data = Get-BME280Data -Device $device
PS /home/pi> $data

Temperature Pressure Humidity
----------- -------- --------
      26.08  1009.41    29.21

PS /home/pi> "Temperature in Fahrenheit = $($data.Temperature * 1.8 + 32)"
Temperature in Fahrenheit = 76.69
```