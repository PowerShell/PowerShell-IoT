# Example on how to interact with Scroll pHat

With this example, we will see how we can interact with [Scroll pHat](https://shop.pimoroni.com/products/scroll-phat).

## Information

After reading the [driver's data sheet](http://www.issi.com/WW/pdf/31FL3730.pdf) we know the following:

There are three "types" of registers: Configuration register, Update register and data registers.
The configuration register value is set to have the expected behaviour of this pHat.

There are 11 data registers, ranging from address 0x01 to 1x0B.
Each register holds 1byte, but since ScrollPHat only has 5 lines, only 5bits are used.
To set the LED on, you need to set the correspondent bits as 1, as example, to achieve the following:

![](https://i.imgur.com/nII0q7B.jpg)

we need to set the register 1 with data 0x0D (0000 1101).

## Software setup

### Install PowerShell Core on Raspberry Pi

Installation instructions can be found [here](https://github.com/MicrosoftDocs/PowerShell-Docs/blob/d5263484cf6f29148b6e07c7b3e1d9376a5fd635/reference/docs-conceptual/install/install-raspbian.md#raspberry-pi-os).

### Enable I2C interface on Raspberry Pi

1. `sudo raspi-config`
2. `5 Interfacing options`
3. `P5 I2C`
4. `Would you like ARM I2C interface to be enabled -> Yes`

Start PowerShell (**with sudo, so that you can access the I2C bus**)

```powershell
sudo pwsh

git clone https://github.com/PowerShell/PowerShell-IoT.git #if you haven't already
./PowerShell-IoT/Examples/Microsoft.PowerShell.IoT.Scroll_pHat/Microsoft.PowerShell.IoT.SadJoey.ps1
```

After running this code, you should see a "Sad Joey" on your Scroll pHat.

Note: What's "Sad Joey"? - #SadJoey became "popular" meme/hastag [on twitter](https://twitter.com/search?q=%23sadJoey&src=typd) during the #PSConfEU 2018

This is what you should see:

![](https://i.imgur.com/112YDk4.jpg)