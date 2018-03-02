$script:CalibrationData = @{}
$script:Device = $null

# EXPORTED

function Get-BME280Device
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [int]
        $Id = 0x77
    )
    $script:Device = Get-I2CDevice -Id $Id -FriendlyName BME280
    return $script:Device
}

function Get-BME280ChipID
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.IoT.I2CDevice]
        $Device = $script:Device
    )
    $Device = CreateDeviceIfNotExist -Device $Device

    return @{
        Device = $Device
        ChipId = Get-I2CRegister -Device $Device -Register 0xD0 -Raw
    }
}

# Units of returned data: temperature in degrees Celsius, pressure in hPa, relative humidity in %
function Get-BME280Data
{
    param
    (
		[Parameter(ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.IoT.I2CDevice] $Device = $script:Device,

		[Parameter(Mandatory=$false)]
        [string] $Mode,

		[Parameter(Mandatory=$false)]
        [string] $Oversampling
    )
    $Device = CreateDeviceIfNotExist -Device $Device

	Read-CalibrationData $Device
	Set-BME280Config $Device $Mode $Oversampling

    # read raw temperature, humidity and pressure measurement output data
    $adc = Get-I2CRegister -Device $Device -Register 0xF7 -ByteCount 8 -Raw

    [int] $adc_P = $adc[0]
    $adc_P = ($adc_P -shl 8) -bor $adc[1]
    $adc_P = ($adc_P -shl 4) -bor ($adc[2] -shr 4)

    [int] $adc_T = $adc[3]
    $adc_T = ($adc_T -shl 8) -bor $adc[4]
    $adc_T = ($adc_T -shl 4) -bor ($adc[5] -shr 4)

    [int] $adc_H = $adc[6]
    $adc_H = ($adc_H -shl 8) -bor $adc[7]

    [int] $TFine = Calc-T-Fine $adc_T $script:CalibrationData[$Device]
    [float] $Temperature = (($TFine * 5 + 128) -shr 8) / [float]100;

    [float] $Pressure = Compensate_P $adc_P $script:CalibrationData[$Device] $TFine
	$Pressure = $Pressure / 100

	[float] $Humidity = Compensate_H $adc_H $script:CalibrationData[$Device] $TFine
	$Humidity = $Humidity / 100

	$result = [pscustomobject]@{
    Temperature=$Temperature;
    Pressure=$Pressure;
	Humidity=$Humidity}

	$result
}

# INTERNAL

function CreateDeviceIfNotExist
{
    param
    (
        [Microsoft.PowerShell.IoT.I2CDevice] $Device
    )

    if (-not $Device)
    {
        $script:Device = Get-BME280Device
        return $script:Device
    }
    return $Device
}

function Read-CalibrationData
{
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.IoT.I2CDevice] $Device
    )

    # read calibration data from sensor
    $cd1 = Get-I2CRegister -Device $Device -Register 0x88 -ByteCount 25 -Raw
    $cd2 = Get-I2CRegister -Device $Device -Register 0xE1 -ByteCount 7 -Raw

    [uint16] $T1 = $cd1[1]
             $T1 = ($T1 -shl 8) -bor $cd1[0]

    [int16]  $T2 = $cd1[3]
             $T2 = ($T2 -shl 8) -bor $cd1[2]

    [int16]  $T3 = $cd1[5]
             $T3 = ($T3 -shl 8) -bor $cd1[4]

    [uint16] $P1 = $cd1[7]
             $P1 = ($P1 -shl 8) -bor $cd1[6]

    [int16]  $P2 = $cd1[9]
             $P2 = ($P2 -shl 8) -bor $cd1[8]

    [int16]  $P3 = $cd1[11]
             $P3 = ($P3 -shl 8) -bor $cd1[10]

    [int16]  $P4 = $cd1[13]
             $P4 = ($P4 -shl 8) -bor $cd1[12]

    [int16]  $P5 = $cd1[15]
             $P5 = ($P5 -shl 8) -bor $cd1[14]

    [int16]  $P6 = $cd1[17]
             $P6 = ($P6 -shl 8) -bor $cd1[16]

    [int16]  $P7 = $cd1[19]
             $P7 = ($P7 -shl 8) -bor $cd1[18]

    [int16]  $P8 = $cd1[21]
             $P8 = ($P8 -shl 8) -bor $cd1[20]

    [int16]  $P9 = $cd1[23]
             $P9 = ($P9 -shl 8) -bor $cd1[22]

    [byte]   $H1 = $cd1[24]

    [int16]  $H2 = $cd2[1]
             $H2 = ($H2 -shl 8) -bor $cd2[0]

    [byte]   $H3 = $cd2[2]

    [int16]  $H4 = $cd2[3]
             $H4 = ($H4 -shl 4) -bor ($cd2[4] -band 0x00FF)

    [int16]  $H5 = $cd2[5]
             $H5 = ($H5 -shl 4) -bor ($cd2[4] -band 0xFF00)

    [sbyte]  $H6 = $cd2[6]

    $cd_final = [pscustomobject]@{
    T1=$T1;
    T2=$T2;
    T3=$T3;

    P1=$P1;
    P2=$P2;
    P3=$P3;
    P4=$P4;
    P5=$P5;
    P6=$P6;
    P7=$P7;
    P8=$P8;
    P9=$P9;

    H1=$H1;
    H2=$H2;
    H3=$H3;
    H4=$H4;
    H5=$H5;
    H6=$H6}

    $script:CalibrationData[$Device] = $cd_final
}

function Set-BME280Config
{
    param
    (
		[Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.IoT.I2CDevice] $Device,

		[Parameter(Mandatory=$false)]
        [string] $Mode,

		[Parameter(Mandatory=$false)]
        [string] $Oversampling
    )
	
    # set oversampling of humidity data to ×2
    [byte] $reg_ctrl_hum = 0xF2
    [byte] $reg_ctrl_hum_value = [Convert]::ToByte("00000010",2)

    # set forced mode, set oversampling for temperature and pressure data to x2
    [byte] $reg_ctrl_meas = 0xF4
    [byte] $reg_ctrl_meas_value = [Convert]::ToByte("01001001",2)

    Set-I2CRegister -Device $Device -Register $reg_ctrl_hum -Data $reg_ctrl_hum_value
    Set-I2CRegister -Device $Device -Register $reg_ctrl_meas -Data $reg_ctrl_meas_value
}

# Calculate variable TFine (signed 32 bit) that carries a fine resolution temperature value over to the pressure and humidity compensation formula
function Calc-T-Fine
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [int] $adc_T,

        [ValidateNotNullOrEmpty()]
        [pscustomobject] $cd
    )

    [int] $var1 = (((($adc_T -shr 3) - ([int]$cd.T1 -shl 1))) * ([int]$cd.T2)) -shr 11
    [int] $var2 = ((((($adc_T -shr 4) - ([int]$cd.T1)) * (($adc_T -shr 4) - ([int]$cd.T1))) -shr 12) * ([int]$cd.T3)) -shr 14
    [int] $TFine = $var1 + $var2
    $TFine
}

# Returns pressure in Pa as unsigned 32 bit integer in Q24.8 format (24 integer bits and 8 fractional bits).
# Output value of “24674867” represents 24674867/256 = 96386.2 Pa = 963.862 hPa
function Compensate_P
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [int] $adc_P,

        [ValidateNotNullOrEmpty()]
        [pscustomobject] $cd,

		[ValidateNotNullOrEmpty()]
        [int] $t_fine
    )

    [int64] $var1 = ([int64]$t_fine) - 128000;
    [int64] $var2 = $var1 * $var1 * [int64]$cd.P6;
    $var2 = $var2 + (($var1*[int64]$cd.P5) -shl 17);
    $var2 = $var2 + (([int64]$cd.P4) -shl 35);
    $var1 = (($var1 * $var1 * [int64]$cd.P3) -shr 8) + (($var1 * [int64]$cd.P2) -shl 12);
    $var1 = (((([int64]1) -shl 47)+$var1))*([int64]$cd.P1) -shr 33;
    if ($var1 -eq 0)
    {
        return 0 # avoid exception caused by division by zero
    }
    [int64] $p = 1048576 - $adc_P;
    $p = ((($p -shl 31)-$var2)*3125)/$var1;
    $var1 = (([int64]$cd.P9) * ($p -shr 13) * ($p -shr 13)) -shr 25;
    $var2 = (([int64]$cd.P8) * $p) -shr 19;
    $p = (($p + $var1 + $var2) -shr 8) + (([int64]$cd.P7) -shl 4);
	$p = [uint32]$p/256;
	$p
}

# Returns humidity in %RH as unsigned 32 bit integer in Q22.10 format (22 integer and 10 fractional bits).
# Output value of “47445” represents 47445/1024 = 46.333 %RH
function Compensate_H
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [int] $adc_H,

        [ValidateNotNullOrEmpty()]
        [pscustomobject] $cd,

		[ValidateNotNullOrEmpty()]
        [int] $t_fine
    )

    [int32] $v_x1_u32r = ($t_fine - ([int32]76800))
    $v_x1_u32r = ((((($adc_H -shl 14) - (([int32]$cd.H4) -shl 20) - (([int32]$cd.H5) * $v_x1_u32r)) +
    ([int32]16384)) -shr 15) * ((((((($v_x1_u32r * ([int32]$cd.H6)) -shr 10) * ((($v_x1_u32r *
    ([int32]$cd.H3)) -shr 11) + ([int32]32768))) -shr 10) + ([int32]2097152)) *
    ([int32]$cd.H2) + 8192) -shr 14))
    $v_x1_u32r = ($v_x1_u32r - ((((($v_x1_u32r -shr 15) * ($v_x1_u32r -shr 15)) -shr 7) * ([int32]$cd.H1)) -shr 4))
    if ($v_x1_u32r -lt 0) { $v_x1_u32r = 0 }
    if ($v_x1_u32r -gt 419430400) {$v_x1_u32r = 419430400}
    $v_x1_u32r = ($v_x1_u32r -shr 12)*100 / 1024
	$v_x1_u32r
}