# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

Describe "PowerShell IoT tests" {
    BeforeAll {
        Enter-PSSession -HostName raspberry -UserName pi
    }
    Context "I2C tests" {
        BeforeAll {
            $PSVersionTable
            Import-Module Microsoft.PowerShell.IoT.BME280
        }
        It "Can get the the BME280 I2C device" {
            $device = Get-BME280Device -Id 0x76
            $device | Should -Not -BeNullOrEmpty
        }
        It "Can get the BME280 data" {
            $data = Get-BME280Data
            $data | Should -Not -BeNullOrEmpty
        }
    }
}