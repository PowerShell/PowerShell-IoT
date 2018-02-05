@{
GUID="eb74e8da-9ae2-482a-a648-e96550fb8739"
Author="Microsoft Corporation"
CompanyName="Microsoft Corporation"
Copyright="© Microsoft Corporation. All rights reserved."
Description='PowerShell module for working with Bosch Sensortec BME280 sensor.'
ModuleVersion="1.0.0.0"
PowerShellVersion="3.0"
FunctionsToExport = @('Get-BME280ChipID','Get-BME280Data')
DotNetFrameworkVersion = 4.5
CmdletsToExport = '*'
AliasesToExport = @()
NestedModules=@('psiot.dll','Microsoft.PowerShell.IoT.BME280.psm1')
HelpInfoURI = 'https://go.microsoft.com/fwlink/?LinkId=393254'
}
