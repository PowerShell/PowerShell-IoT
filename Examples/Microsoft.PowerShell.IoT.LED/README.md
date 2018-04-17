# Example module Microsoft.PowerShell.IoT.LED

This simple PowerShell module is for turning on/off a single color LED.

![An LED is on](https://i.imgur.com/nJPJ9Vk.jpg)

This showcases GPIO functionality of [the Microsoft.PowerShell.IoT module](../../README.md).

## Hardware setup

Hardware pieces:

* [Breadboard](https://en.wikipedia.org/wiki/Breadboard) (Optional)
* Male to female [jumper wires](https://en.wikipedia.org/wiki/Jump_wire)
* 1 270-330Ω resistor
* A [single-color LED](http://upload.wikimedia.org/wikipedia/commons/e/e8/LEDs.jpg)

## Wiring diagram

![wiring](https://i.imgur.com/lCaxMWZ.png)

## Software setup

### Install PowerShell Core on Raspberry Pi

Installation instructions can be found [here](https://github.com/PowerShell/PowerShell/tree/master/docs/installation/linux.md#raspbian).

### Start Powershell and install modules

```powershell
sudo pwsh

Install-Module -Name Microsoft.PowerShell.IoT

git clone https://github.com/PowerShell/PowerShell-IoT.git

Import-Module ./PowerShell-IoT/Examples/Microsoft.PowerShell.IoT.LED
```

### Usage

```powershell
# Turn LED on
Set-Led -Pin 1 -State On
# or
Set-Led 1 On
# or
[PSCustomObject]@{Pin=1; State="On"} | Set-Led

# Turn LED off
Set-Led 1 Off
```
