---
external help file: Microsoft.PowerShell.IoT.dll-Help.xml
Module Name: Microsoft.PowerShell.IoT
online version:
schema: 2.0.0
---

# Get-I2CRegister

## SYNOPSIS
Reads the value of a register of an **I2CDevice**.

## SYNTAX

```
Get-I2CRegister [-Device] <I2CDevice> [-Register] <UInt16> [[-ByteCount] <Byte>] [-Raw]
 [<CommonParameters>]
```

## DESCRIPTION

Reads the value of a register of an **I2CDevice**.

## EXAMPLES

### Example 1 - Read the chip identifier from the register

```powershell
$ChipId = Get-I2CRegister -Device $Device -Register 0xD0 -Raw
```

## PARAMETERS

### -ByteCount

The number of bytes to be returned from the register.

```yaml
Type: Byte
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Device

An **I2CDevice** object to be read from.

```yaml
Type: I2CDevice
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Raw

Returns only the value stored in the register rather than a **I2CDeviceRegisterData** object.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Register

The address of the register to be read.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose,
-WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.PowerShell.IoT.I2CDevice

### System.UInt16

### System.Byte

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
