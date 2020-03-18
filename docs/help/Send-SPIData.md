---
external help file: Microsoft.PowerShell.IoT.dll-Help.xml
Module Name: Microsoft.PowerShell.IoT
online version:
schema: 2.0.0
---

# Send-SPIData

## SYNOPSIS
Sends data on an Serial Peripheral Interface (SPI) channel.

## SYNTAX

```
Send-SPIData [-Data] <Byte[]> [[-Channel] <UInt32>] [[-Frequency] <UInt32>] [-Raw] [<CommonParameters>]
```

## DESCRIPTION

Sends data on an Serial Peripheral Interface (SPI) channel.

## EXAMPLES

### Example 1

```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Channel

The channel number to be written to.

```yaml
Type: UInt32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Data

The data to be written to the channel.

```yaml
Type: Byte[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Frequency

The frequency in Hertz that is used to send data on the channel.

```yaml
Type: UInt32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Raw

Return the result code of the write operation rather than a full **SPIData** object.

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

### System.Byte[]

### System.UInt32

### System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
