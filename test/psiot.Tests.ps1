# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

Describe "PowerShell IoT tests" {
    BeforeAll {
        $Global:SESSION = New-PSSession -HostName raspberry -UserName pi
    }
    Context "I2C tests" {
        BeforeAll {
            Invoke-Command -Session $Global:SESSION -ScriptBlock {
                Import-Module Microsoft.PowerShell.IoT.BME280
            }

        }
        It "Can get the the BME280 I2C device" {
            $device = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                return Get-BME280Device -Id 0x76
            }
            $device | Should -Not -BeNullOrEmpty
            $device.Id | Should -Be 118
            $device.FriendlyName | Should -Be "BME280"
        }
        It "Can get the BME280 data" {
            $data = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                return Get-BME280Data
            }
            $data.Temperature | Should -Not -BeNullOrEmpty
            $data.Pressure | Should -Not -BeNullOrEmpty
            $data.Humidity | Should -Not -BeNullOrEmpty
        }
    }
}