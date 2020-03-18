---
external help file: Microsoft.PowerShell.IoT.dll-Help.xml
Module Name: Microsoft.PowerShell.IoT
online version:
schema: 2.0.0
---

# Set-I2CRegister

## SYNOPSIS
Writes a value to a register of an **I2CDevice**.

## SYNTAX

```
Set-I2CRegister [-Device] <I2CDevice> [-Register] <UInt16> [-Data] <Byte[]> [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

Writes a value to a register of an **I2CDevice**.

## EXAMPLES

### Example 1

```powershell
Set-I2CRegister -Device $Device -Register 0x00 -Data 0xF1
```

## PARAMETERS

### -Data

The data to be written to the register.

```yaml
Type: Byte[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Device

An **I2CDevice** object to be written to.

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

### -PassThru

Normally this cmdlet does not return any output. When **PassThru** is used, the cmdlet returns a
**I2CDeviceRegisterData** object showing the value that was set.

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

The address of the register to be written.

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

### System.Byte[]

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
