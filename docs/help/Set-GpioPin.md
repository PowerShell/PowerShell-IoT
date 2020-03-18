---
external help file: Microsoft.PowerShell.IoT.dll-Help.xml
Module Name: Microsoft.PowerShell.IoT
online version:
schema: 2.0.0
---

# Set-GpioPin

## SYNOPSIS
Writes a value to a GPIO pin.

## SYNTAX

```
Set-GpioPin [-Id] <Int32[]> [-Value] <SignalLevel> [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

Writes a value to a GPIO pin.

## EXAMPLES

### Example 1 - Write a value to a GPIO pin

This example writes the value of a variable to GPIO pin 2.

```powershell
Set-GpioPin -Id 2 -Value $value
```

### Example 2 - Set a GPIO pin state to **Low**

This example sets the state of GPIO pin 0  to **Low**.

```powershell
Set-GpioPin -Id 0 -Value "Low"
```

## PARAMETERS

### -Id

The ID number of the pin to be written.

```yaml
Type: Int32[]
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
**PinData** object showing the value that was set.

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

### -Value

The value to set on the GPIO pin.

```yaml
Type: SignalLevel
Parameter Sets: (All)
Aliases:
Accepted values: Low, High

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

### System.Int32[]

### Microsoft.PowerShell.IoT.SignalLevel

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
