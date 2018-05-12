# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
Import-Module Microsoft.PowerShell.IoT

[int]$DeviceAddress = 0x60
######### Configuration Register and Value #########
[int]$ConfigurationRegisterAddress = 0x00
[int]$ConfigurationRegisterValue = 0x1B

######### Data Registers and value #########
[int[]]$DataRegisterAddress = 0x04 ..0x08
[int[]]$values = 0x12,0x08,0x08,0x08,0x12
######### Brightness Register and value #########
[int]$BrightnessRegisterAddress = 0x0D
[int]$BrightnessRegisterValue = 0x08 #Lowest intensity

######### Get the device and set the Configuration Register
$Device = Get-I2CDevice -Id $DeviceAddress -FriendlyName phat
Set-I2CRegister -Device $Device -Register $ConfigurationRegisterAddress -Data $ConfigurationRegisterValue

######## Brightness #####
Set-I2CRegister -Device $Device -Register $BrightnessRegisterAddress -Data $BrightnessRegisterValue

######### Write the #sadJoey pattern to the Data registers #########
$i = 0
foreach ($register in $DataRegisterAddress) {
    Set-I2CRegister -Device $Device -Register $register -Data $values[$i]
    $i++
}

#In order to update the registers, we need to write something to the column register, accoding to the datasheet: "A write operation of any 8-bit value to the Update Column Register is required to update the Data Registers"
[int]$UpdateRegisterAddress = 0x0C
[int]$UpdateValue = 0xFF

#After executing this instruction, a Sad Joey should appear on your pHat :)
Set-I2CRegister -Device $Device -Register $UpdateRegisterAddress -Data $UpdateValue