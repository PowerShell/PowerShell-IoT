# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

@{
    GUID="eb74e8da-9ae2-482a-a648-e96550fb8745"
    Author="Microsoft Corporation"
    CompanyName="Microsoft Corporation"
    Copyright="© Microsoft Corporation. All rights reserved."
    Description='A PowerShell module for interacting with hardware sensors and devices using common protocols: GPIO, I2C & SPI.'
    ModuleVersion="0.2.0"
    FunctionsToExport = '*'
    CmdletsToExport = '*'
    AliasesToExport = @()
    NestedModules=@('Microsoft.PowerShell.IoT.dll')
    HelpInfoURI = 'https://github.com/PowerShell/PowerShell-IoT'
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = 'IoT','RaspberryPi','Raspbian','GPIO','I2C','SPI'

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/PowerShell/PowerShell-IoT/blob/master/LICENSE.txt'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/PowerShell/PowerShell-IoT'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = '## 0.2.0

Started using System.Device.Gpio

            ## 0.1.1

Minor bug fixes

            ## 0.1.0

Initial preview of PowerShell IoT
'
        }
        
    }
}
