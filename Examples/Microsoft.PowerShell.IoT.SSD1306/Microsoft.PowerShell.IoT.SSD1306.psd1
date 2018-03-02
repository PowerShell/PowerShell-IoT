@{
    GUID="eb74e8da-9ae2-482a-a648-e96550fb8741"
    Author="Microsoft Corporation"
    CompanyName="Microsoft Corporation"
    Copyright="© Microsoft Corporation. All rights reserved."
    Description='PowerShell module for working with SSD1306 I2C OLED display.'
    ModuleVersion="1.0.0.0"
    PowerShellVersion="3.0"
    FunctionsToExport = @('New-OledDisplay','Set-OledText')
    DotNetFrameworkVersion = 4.5
    CmdletsToExport = '*'
    AliasesToExport = @()
    NestedModules=@('PSIoT','Microsoft.PowerShell.IoT.SSD1306.psm1')
    HelpInfoURI = 'https://go.microsoft.com/fwlink/?LinkId=393254'
}
