# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

@{
    GUID="0432ee36-7e87-4a21-814f-8feb17974647"
    Author="Microsoft Corporation"
    CompanyName="Microsoft Corporation"
    Copyright="© Microsoft Corporation. All rights reserved."
    Description='PowerShell module for controling a fan over GPIO.'
    ModuleVersion="0.1.0"
    FunctionsToExport = @('Enable-Fan','Disable-Fan')
    CmdletsToExport = @()
    AliasesToExport = @()
    RootModule = 'Microsoft.PowerShell.IoT.Fan.psm1'
    NestedModules=@('Microsoft.PowerShell.IoT')
    HelpInfoURI = 'https://github.com/PowerShell/PowerShell-IoT'
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = 'IoT','RaspberryPi','Raspbian'

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/PowerShell/PowerShell-IoT/blob/master/LICENSE.txt'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/PowerShell/PowerShell-IoT'
        }
    }
}
