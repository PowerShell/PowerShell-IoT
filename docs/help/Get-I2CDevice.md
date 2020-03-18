---
external help file: Microsoft.PowerShell.IoT.dll-Help.xml
Module Name: Microsoft.PowerShell.IoT
online version:
schema: 2.0.0
---

# Get-I2CDevice

## SYNOPSIS
Returns an **I2CDevice** object.

## SYNTAX

```
Get-I2CDevice [-Id] <Int32> [[-FriendlyName] <String>] [<CommonParameters>]
```

## DESCRIPTION

Returns an **I2CDevice** object.}

## EXAMPLES

### Example 1 - Get an I2C device object

```powershell
$Device = Get-I2CDevice -Id $Id -FriendlyName $FriendlyName
```

## PARAMETERS

### -FriendlyName

The friendly name of the device.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Id

The I2c address of the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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

### System.Int32

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
