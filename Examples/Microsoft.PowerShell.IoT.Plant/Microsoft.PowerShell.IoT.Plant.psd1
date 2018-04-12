# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

@{
    GUID="eb74e8da-9ae2-482a-a648-e96550fb8731"
    Author="Microsoft Corporation"
    CompanyName="Microsoft Corporation"
    Copyright="© Microsoft Corporation. All rights reserved."
    Description='PowerShell module for plant growth'
    ModuleVersion="0.1.0"
    FunctionsToExport = '*'
    CmdletsToExport = '*'
    AliasesToExport = @()
    NestedModules=@('Microsoft.PowerShell.IoT','Microsoft.PowerShell.IoT.Plant.psm1')
    HelpInfoURI = 'https://github.com/PowerShell/PowerShell-IoT'
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = 'IoT','RaspberryPi','Raspbian','Plant'

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/PowerShell/PowerShell-IoT/blob/master/LICENSE.txt'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/PowerShell/PowerShell-IoT'
        }
    }
}
