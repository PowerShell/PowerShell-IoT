# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Inspired from https://github.com/sparkfun/SparkFun_ADXL345_Arduino_Library

# Device registers and parameters

$script:ADXL345_ADDRESS        = 0x53        # I2c address
$script:ADXL345_POWER_CTL      = 0x2D        # Power-Saving Features Control
$script:ADXL345_DATAX0         = 0x32        # X-Axis Data 0
$script:ADXL345_DATAX1         = 0x33        # X-Axis Data 1
$script:ADXL345_DATAY0         = 0x34        # Y-Axis Data 0
$script:ADXL345_DATAY1         = 0x35        # Y-Axis Data 1
$script:ADXL345_DATAZ0         = 0x36        # Z-Axis Data 0
$script:ADXL345_DATAZ1         = 0x37        # Z-Axis Data 1
$script:ADXL345_GAINX          = 0.00376390  # Gain to convert X value in g
$script:ADXL345_GAINY          = 0.00376009  # Gain to convert Y value in g
$script:ADXL345_GAINZ          = 0.00349265  # Gain to convert Z value in g

# Published functions
function Get-ADXL345Device {
    [CmdletBinding()]
    param
    (
        [ValidateNotNullOrEmpty()]
        [int]
        $Id = $script:ADXL345_ADDRESS,

        [ValidateNotNullOrEmpty()]
        [string]
        $FriendlyName = "ADXL345"
    )

    $Device = Get-I2CDevice -Id $Id -FriendlyName $FriendlyName
    InitializeDevice -Device $Device
    return $Device
}

function Get-ADXL345Data {
    param (
        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.IoT.I2CDevice] 
        $Device = (Get-ADXL345Device),

        [Parameter()]
        [Double]
        $Limit,

        [Switch]
        $Raw
    )

    try {
        $xValue0 = Get-I2CRegister -Device $Device -Register $script:ADXL345_DATAX0 -ByteCount 1
        $xValue1 = Get-I2CRegister -Device $Device -Register $script:ADXL345_DATAX1 -ByteCount 1
        $xValue = [int16]($xValue1.Data[0]) -shl 8 -bor [int16]($xValue0.Data[0])
    
        $yValue0 = Get-I2CRegister -Device $Device -Register $script:ADXL345_DATAY0 -ByteCount 1
        $yValue1 = Get-I2CRegister -Device $Device -Register $script:ADXL345_DATAY1 -ByteCount 1
        $yValue = [int16]($yValue1.Data[0]) -shl 8 -bor [int16]($yValue0.Data[0])
    
        $zValue0 = Get-I2CRegister -Device $Device -Register $script:ADXL345_DATAZ0 -ByteCount 1
        $zValue1 = Get-I2CRegister -Device $Device -Register $script:ADXL345_DATAZ1 -ByteCount 1
        $zValue = [int16]($zValue1.Data[0]) -shl 8 -bor [int16]($zValue0.Data[0])
    }
    catch {
        Throw "Unable to retreive data from device '$($Device.FriendlyName)'. Message: $($_.Exception.Message)"
    }

    if (-not $Raw) {
        $xValue = $xValue * $script:ADXL345_GAINX
        $yValue = $yValue * $script:ADXL345_GAINY
        $zValue = $zValue * $script:ADXL345_GAINZ
    }

    if ($Limit) {
        $xValue = FilterValue -Value $xValue -Maximum $Limit
        $yValue = FilterValue -Value $yValue -Maximum $Limit
        $zValue = FilterValue -Value $zValue -Maximum $Limit
    }

    return [PSObject]@{x = $xValue; y = $yValue; z = $zvalue}
}

# Internal functions
function InitializeDevice {
    Param (                 
        [Parameter(Mandatory)]
        [Microsoft.PowerShell.IoT.I2CDevice]
        $Device
    )

    try {
        Set-I2CRegister -Device $Device -Register $script:ADXL345_POWER_CTL -Data 0x00
        Set-I2CRegister -Device $Device -Register $script:ADXL345_POWER_CTL -Data 0x10
        Set-I2CRegister -Device $Device -Register $script:ADXL345_POWER_CTL -Data 0x08
    }
    catch {
        Throw "Unable to initialize device '$($Device.FriendlyName)'. Message: $($_.Exception.Message)"
    }
}

function FilterValue {
    param (
        [Parameter(Mandatory)]
        [Double]
        $Value,

        [Parameter(Mandatory)]
        [Double]
        $Maximum
    )

    if ($Value -ge 0) {
        return [Math]::Min($value, $Maximum)
    } else {
        return [Math]::Max($Value, -$Maximum)
    }
}
