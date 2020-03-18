---
external help file: Microsoft.PowerShell.IoT.dll-Help.xml
Module Name: Microsoft.PowerShell.IoT
online version:
schema: 2.0.0
---

# Get-GpioPin

## SYNOPSIS
Reads data from a GPIO pin.

## SYNTAX

```
Get-GpioPin [[-Id] <Int32[]>] [[-PullMode] <PullMode>] [-Raw] [<CommonParameters>]
```

## DESCRIPTION

Reads data from a GPIO pin.

## EXAMPLES

### Example 1 - Read raw data from a GPIO pin

```powershell
$raw = Get-GpioPin -Id 5 -Raw
```

## PARAMETERS

### -Id

The ID number of the pin to be read.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -PullMode

Specifies the mode to use when reading the data. Possible values are: **Off**, **PullDown**,
**PullUp**. Consult the documentation of your chipset to determine the requirements.

```yaml
Type: PullMode
Parameter Sets: (All)
Aliases:
Accepted values: Off, PullDown, PullUp

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Raw

When this switch is used, the cmdlet only returns a pin state value of **High** or **Low**.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose,
-WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32[]

### System.Nullable`1[[Microsoft.PowerShell.IoT.PullMode, Microsoft.PowerShell.IoT, Version=0.1.1.0, Culture=neutral, PublicKeyToken=null]]

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Set-GpioPin](Set-GpioPin.md)
