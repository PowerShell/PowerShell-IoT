@{

# Root module file
RootModule = 'Microsoft.PowerShell.IoT.ADXL345.psm1'

# Version number of this module.
ModuleVersion = '0.1.0'

# ID used to uniquely identify this module
GUID = '78f2d4bb-195e-4143-8f54-0a6d8c68612e'

# Author of this module
Author = 'Julien Nury'

# Description of the functionality provided by this module
Description = 'A set of functions to interact with ADXL345s accelerometer thru I2C'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @('Microsoft.PowerShell.IoT')

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-ADXL345Device', 'Get-ADXL345Data'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

}

