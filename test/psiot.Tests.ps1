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
    Context "GPIO tests" {
        It "Can get and set a GPIO's pin value" {
            $before = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                Set-GpioPin -Id 26 -Value High
                return Get-GpioPin -Id 22
            }
            $before.Id | Should -Be 22
            $before.Value | Should -Be "High"

            $after = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                Set-GpioPin -Id 26 -Value Low
                return Get-GpioPin -Id 22
            }
            $before.Id | Should -Be 22
            $before.Value | Should -Be "Low"
        }
        It "Can use the -Raw flag to get the raw value" {
            $rawValue = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                Set-GpioPin -Id 22 -Value High
                return Get-GpioPin -Id 26 -Raw
            }
            $rawValue | Should -Be "High"
        }
        It "Read non-connected pin with PullDown and return Low" {
            $result = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                return Get-GpioPin -Id 23 -PullMode PullDown -Raw
            }
            $result | Should -Be "Low"
        }
        It "Read non-connected pin with PullUp and return High" {
            $result = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                return Get-GpioPin -Id 23 -PullMode PullUp -Raw
            }
            $result | Should -Be "High"
        }
    }
    Context "SPI tests" {
        # SPI test: LIS3DH motion sensor; datasheet: www.st.com/resource/en/datasheet/lis3dh.pdf
        # Read "WHO_AM_I (0Fh)" register; value should be 0x33
        It "Can read data from the LIS3DH motion sensor" {
            $result = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                $d = @(0x8F,0x0)
                return Send-SPIData -Channel 0 -Data $d
            }
            $result.Channel | Should -Be 0
            $result.Data[0] | Should -Be 0x8F
            $result.Responce[1] | Should -Be 0x33
            $result.Frequency | Should -Be 500000
        }
        It "Can use the -Raw flag to get the raw value" {
            $result = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                $d = @(0x8F,0x0)
                return Send-SPIData -Channel 0 -Data $d -Raw
            }
            $result[1] | Should -Be 0x33
        }
    }
}