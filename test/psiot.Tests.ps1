# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

Describe "PowerShell IoT tests" {
    BeforeAll {
        # This creates the session to the test Pi. The hostname maps to a random IP
        $Global:SESSION = New-PSSession -HostName raspberry -UserName pi
    }
    Context "I2C tests" {
        BeforeAll {
            Invoke-Command -Session $Global:SESSION -ScriptBlock {
                # Import the example BME280 which wraps PowerShell IoT cmdlets
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
        # GPIO pins can either act as an input or output pin. In other words,
        # you can either set a pin's value or read a pin's value. For example,
        # if you set pin 20 to "High" (aka 1) and attempt to read the value of
        # pin 20, you will not get the result of your previous set operation.

        # To get around this limitation, on the test Raspberry Pi we have two pins
        # (22 and 26) connected. By doing this, we can set the value on pin 22 and
        # read that value on pin 26. This next test demonstrates that.
        It "Can get and set a GPIO's pin value" {
            $highValueResult = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                Set-GpioPin -Id 26 -Value High
                return Get-GpioPin -Id 22
            }
            $highValueResult.Id | Should -Be 22
            $highValueResult.Value | Should -Be "High"

            $lowValueResult = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                Set-GpioPin -Id 26 -Value Low
                return Get-GpioPin -Id 22
            }
            $lowValueResult.Id | Should -Be 22
            $lowValueResult.Value | Should -Be "Low"
        }
        It "Can use the -Raw flag to get the raw value" {
            $rawValue = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                Set-GpioPin -Id 26 -Value High
                return Get-GpioPin -Id 22 -Raw
            }
            $rawValue | Should -Be 1
        }
        It "Read non-connected pin with PullDown and return Low" {
            $result = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                return Get-GpioPin -Id 23 -PullMode PullDown -Raw
            }
            $result | Should -Be 0
        }
        It "Read non-connected pin with PullUp and return High" {
            $result = Invoke-Command -Session $Global:SESSION -ScriptBlock {
                return Get-GpioPin -Id 23 -PullMode PullUp -Raw
            }
            $result | Should -Be 1
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
