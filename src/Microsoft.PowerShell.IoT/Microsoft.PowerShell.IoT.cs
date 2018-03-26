// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System;
using System.Collections;
using System.Management.Automation;  // PowerShell namespace.

namespace Microsoft.PowerShell.IoT
{
    public class I2CDevice
    {
        internal Unosquare.RaspberryIO.Gpio.I2CDevice device = null;

        public string FriendlyName { get; set; }
        public int Id { get; set; }

        public I2CDevice(Unosquare.RaspberryIO.Gpio.I2CDevice device, int Id, string FriendlyName)
        {
            this.device = device;
            this.Id = Id;
            this.FriendlyName = FriendlyName;
        }

        public override string ToString()
        {
            if (string.IsNullOrEmpty(this.FriendlyName))
            {
                return this.Id.ToString();
            }
            else
            {
                return this.FriendlyName;
            }
        }
    }

    public class I2CDeviceRegisterData
    {
        public I2CDevice Device { get; set; }
        public ushort Register { get; set; }
        public byte[] Data { get; set; }

        public I2CDeviceRegisterData(I2CDevice device, ushort register, byte[] data)
        {
            this.Device = device;
            this.Register = register;
            this.Data = data;
        }

        public I2CDeviceRegisterData(I2CDevice device, ushort register)
            : this(device, register, new byte[0])
        {
        }

        public I2CDeviceRegisterData()
            : this(null, 0)
        {
        }
    }

    public enum SignalLevel
    {
        Low = 0,
        High = 1
    }

    public enum PullMode
    {
        Off = 0,
        PullDown = 1,
        PullUp = 2
    }

    public class GpioPinData
    {
        public int Id;
        public SignalLevel Value;
        public Unosquare.RaspberryIO.Gpio.GpioPin PinInfo;

        public GpioPinData(int id, SignalLevel value, Unosquare.RaspberryIO.Gpio.GpioPin pinInfo)
        {
            this.Id = id;
            this.Value = value;
            this.PinInfo = pinInfo;
        }
    }
    
    public class SPIData
    {
        public uint Channel { get; set; }
        public uint Frequency { get; set; }
        public byte[] Data { get; set; }
        public byte[] Responce { get; set; }
        
        public SPIData(uint channel, uint frequency, byte[] data, byte[] responce)
        {
            this.Channel = channel;
            this.Frequency = frequency;
            this.Data = data;
            this.Responce = responce;
        }
    }

    [Cmdlet(VerbsCommon.Get, "I2CDevice")]
    public class GetI2CDevice : Cmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public int Id { get; set; }

        [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 1)]
        public string FriendlyName { get; set; }

        public GetI2CDevice()
        {
            this.FriendlyName = string.Empty;
            this.Id = 0;
        }

        protected override void ProcessRecord()
        {
            WriteObject(new I2CDevice(Unosquare.RaspberryIO.Pi.I2C.AddDevice(this.Id), this.Id, this.FriendlyName));
        }
    }

    [Cmdlet(VerbsCommon.Get, "I2CRegister")]
    public class GetI2CRegister : Cmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public I2CDevice Device { get; set; }

        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 1)]
        public ushort Register { get; set; }

        [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 2)]
        public byte ByteCount { get; set; }

        [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true)]
        public SwitchParameter Raw { get; set; }

        public GetI2CRegister()
        {
            this.ByteCount = 1;
            this.Raw = false;
        }

        protected override void ProcessRecord()
        {
            if (this.ByteCount > 1)
            {
                this.Device.device.Write((byte)this.Register);
                byte[] value = this.Device.device.Read(this.ByteCount);
                if (this.Raw)
                {
                    WriteObject(value);
                }
                else
                {
                    I2CDeviceRegisterData result = new I2CDeviceRegisterData(this.Device, this.Register);
                    result.Data = value;
                    WriteObject(result);
                }
            }
            else
            {
                byte value = this.Device.device.ReadAddressByte(this.Register);
                if (this.Raw)
                {
                    WriteObject(value);
                }
                else
                {
                    I2CDeviceRegisterData result = new I2CDeviceRegisterData(this.Device, this.Register, new byte[1] { value });
                    WriteObject(result);
                }
            }
        }
    }
    
    [Cmdlet(VerbsCommon.Set, "I2CRegister")]
    public class SetI2CRegister : Cmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public I2CDevice Device { get; set; }

        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 1)]
        public ushort Register { get; set; }

        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 2)]
        public byte[] Data { get; set; }

        [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true)]
        public SwitchParameter PassThru { get; set; }

        protected override void ProcessRecord()
        {
            this.Device.device.WriteAddressByte(this.Register, this.Data[0]);
            if (this.PassThru)
            {
                I2CDeviceRegisterData result = new I2CDeviceRegisterData(this.Device, this.Register, this.Data);
                WriteObject(result);
            }
        }
    }

    [Cmdlet(VerbsCommon.Set, "GpioPin")]
    public class SetGpioPin : Cmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public int[] Id { get; set; }

        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 1)]
        public SignalLevel Value { get; set; }

        [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true)]
        public SwitchParameter PassThru { get; set; }

        protected override void ProcessRecord()
        {
            if (this.Id != null)
            {
                foreach (int pinId in this.Id)
                {
                    var pin = Unosquare.RaspberryIO.Pi.Gpio[pinId];
                    pin.PinMode = Unosquare.RaspberryIO.Gpio.GpioPinDriveMode.Output;
                    pin.Write((Unosquare.RaspberryIO.Gpio.GpioPinValue)this.Value);
                    if (this.PassThru)
                    {
                        GpioPinData pinData = new GpioPinData(pinId, this.Value, pin);
                        WriteObject(pinData);
                    }
                }
            }
        }
    }

    [Cmdlet(VerbsCommon.Get, "GpioPin")]
    public class GetGpioPin : Cmdlet
    {
        [Parameter(Mandatory = false, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public int[] Id { get; set; }

        [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 1)]
        public PullMode? PullMode { get; set; }

        [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true)]
        public SwitchParameter Raw { get; set; }

        protected override void ProcessRecord()
        {
            ArrayList pinList = new ArrayList();

            if ((this.Id == null) || (this.Id.Length <= 0))
            {
                foreach (var pin in Unosquare.RaspberryIO.Pi.Gpio.Pins)
                {
                    pinList.Add(pin.PinNumber);
                }
            }
            else
            {
                pinList.AddRange(this.Id);
            }

            foreach(int pinId in pinList)
            {
                var pin = Unosquare.RaspberryIO.Pi.Gpio[pinId];
                try
                {
                    pin.PinMode = Unosquare.RaspberryIO.Gpio.GpioPinDriveMode.Input;
                    if (this.PullMode.HasValue)
                    {
                        pin.InputPullMode = (Unosquare.RaspberryIO.Gpio.GpioPinResistorPullMode)this.PullMode.Value;
                    };
                }
                catch (System.NotSupportedException)
                {
                    // We want to avoid errors like
                    // System.NotSupportedException : Get - GpioPin : Pin Pin15 'BCM 14 (UART Transmit)' does not support mode 'Input'.Pin capabilities are limited to: UARTTXD
                    // at the same time we need to return PinInfo for such pins, so we need to continue processing
                }
                bool pinBoolValue = pin.Read();

                if (this.Raw)
                {
                    WriteObject(pinBoolValue ? SignalLevel.High : SignalLevel.Low);
                }
                else
                {
                    GpioPinData pinData = new GpioPinData(pinId, pinBoolValue ? SignalLevel.High : SignalLevel.Low, pin);
                    WriteObject(pinData);
                }
            }
        }
    }

    [Cmdlet(VerbsCommunications.Send, "SPIData")]
    public class SendSPIData : Cmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
        public byte[] Data { get; set; }

        [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 1)]
        public uint Channel { get; set; }

        [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 2)]
        public uint Frequency { get; set; }

        [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true)]
        public SwitchParameter Raw { get; set; }

        public SendSPIData()
        {
            this.Channel = 0;
            this.Frequency = Unosquare.RaspberryIO.Gpio.SpiChannel.MinFrequency;
        }

        protected override void ProcessRecord()
        {
            var spiChannel = Unosquare.RaspberryIO.Pi.Spi.Channel0;
            if (this.Channel == 1)
            {
                spiChannel = Unosquare.RaspberryIO.Pi.Spi.Channel1;
                Unosquare.RaspberryIO.Pi.Spi.Channel1Frequency = (int)this.Frequency;
            }
            else
            {
                Unosquare.RaspberryIO.Pi.Spi.Channel0Frequency = (int)this.Frequency;
            };

            var responce = spiChannel.SendReceive(this.Data);
            if (this.Raw)
            {
                WriteObject(responce);
            }
            else
            {
                SPIData spiData = new SPIData(this.Channel, this.Frequency, this.Data, responce);
                WriteObject(spiData);
            }
        }
    }
}