# Example module Microsoft.PowerShell.IoT.ADXL345

This PowerShell module is for interacting with [ADXL345 accelerometer](http://www.analog.com/media/en/technical-documentation/data-sheets/ADXL345.pdf) for reading acceleration on 3 axis.

## Hardware setup

Several vendors have breakout boards with ADXL345 sensor. In this example we'll use [SparkFun Triple Axis Accelerometer Breakout](https://www.sparkfun.com/products/9836).

ADXL345 sensor supports both I2C and SPI interfaces; in this example we'll use I2C.

Wiring diagram with Raspberry Pi 3 is like this:

![ADXL345_Wiring](https://user-images.githubusercontent.com/9315492/39673576-40f7e8b4-513f-11e8-8b69-314237f99bd1.png)

## Software setup

### Install PowerShell Core on Raspberry Pi

Installation instructions can be found [here](https://github.com/PowerShell/PowerShell/tree/master/docs/installation/linux.md#raspbian).

### Enable I2C interface on Raspberry Pi

1. `sudo raspi-config`
2. `5 Interfacing options`
3. `P5 I2C`
4. `Would you like ARM I2C interface to be enabled -> Yes`

### Start Powershell and install modules

**Don't forget to start PowerShell with sudo** or you'll be unable to access I2C bus.

```powershell
sudo pwsh
Install-Module -Name Microsoft.PowerShell.IoT
git clone https://github.com/PowerShell/PowerShell-IoT.git
Import-Module ./PowerShell-IoT/Examples/Microsoft.PowerShell.IoT.ADXL345
```

### Collect Data

Simply collect acceleration values in g

```powershell
PS /home/pi> $accelerometer = Get-ADXL345Device
PS /home/pi> Get-ADXL345Data -Device $accelerometer

Name                           Value
----                           -----
y                              -0.03008072
x                              0.0828058
z                              0.86966985
```

Represent current acceleration on the 3 axis with bargraphs

```powershell
PS /home/pi> $accelerometer = Get-ADXL345Device
PS /home/pi> Get-ADXL345Data -Device $accelerometer
PS /home/pi> while ($true) {
    $data = Get-ADXL345Data -Device $accelerometer -Limit 1
    Write-Progress -id 1 -Activity 'X axis' -Status 'Acceleration' -PercentComplete ($data.x * 50 + 50)
    Write-Progress -id 2 -Activity 'Y axis' -Status 'Acceleration' -PercentComplete ($data.y * 50 + 50)
    Write-Progress -id 3 -Activity 'Z axis' -Status 'Acceleration' -PercentComplete ($data.z * 50 + 50)
}

X axis
Acceleration
[ooooooooooooooooooooooooooooooooooooooooooooooooooo                                                 ]
Y axis
Acceleration
[ooooooooooooooooooooooooooooooooooooooooooooooooo                                                   ]
Z axis
Acceleration
[ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo     ]
```