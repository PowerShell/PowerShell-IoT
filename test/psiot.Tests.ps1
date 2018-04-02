# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

Describe "PowerShell IoT tests" {
    BeforeAll {
        $global:SESSION = New-PSSession -HostName raspberry -UserName pi
    }
    Context "GPIO tests" {
        It "Can import the PowerShell IoT module" {
            { Invoke-Command -Session $Global:SESSION -ScriptBlock { Import-Module Microsoft.PowerShell.IoT } } |
                Should -Not -Throw
        }
    }
}