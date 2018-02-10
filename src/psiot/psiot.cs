using System;
using System.Management.Automation;  // PowerShell namespace.

namespace Microsoft.PowerShell.IoT
{
    public class I2CDevice
    {
        internal Unosquare.RaspberryIO.Gpio.I2CDevice device = null;

        public string Name { get; set; }
        public int Id { get; set; }

        public I2CDevice(Unosquare.RaspberryIO.Gpio.I2CDevice device, int Id, string Name)
        {
            this.device = device;
            this.Id = Id;
            this.Name = Name;
        }
    }

    [Cmdlet(VerbsCommon.New, "I2CDevice")]
    public class NewI2CDevice : Cmdlet
    {
        [Parameter(Mandatory = false)]
        public string Name { get; set; }

        [Parameter(Mandatory = true)]
        public int Id { get; set; }
        
        protected override void ProcessRecord()
        {
            WriteObject(new I2CDevice(Unosquare.RaspberryIO.Pi.I2C.AddDevice(this.Id), this.Id, this.Name));
        }
    }

    [Cmdlet(VerbsCommunications.Read, "I2CRegister")]
    public class ReadI2CRegister : Cmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true)]
        public I2CDevice Device { get; set; }

        [Parameter(Mandatory = true)]
        public byte Register { get; set; }

        [Parameter(Mandatory = false)]
        public byte Length { get; set; }

        public ReadI2CRegister()
        {
            this.Length = 1;
        }

        protected override void ProcessRecord()
        {
            if (this.Length > 1)
            {
                this.Device.device.Write(this.Register);
                WriteObject(this.Device.device.Read(this.Length));
            }
            else
            {
                WriteObject(this.Device.device.ReadAddressByte(this.Register));
            }
        }
    }
    
    [Cmdlet(VerbsCommunications.Write, "I2CRegister")]
    public class WriteI2CRegister : Cmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true)]
        public I2CDevice Device { get; set; }

        [Parameter(Mandatory = true)]
        public byte Register { get; set; }

        [Parameter(Mandatory = true)]
        public byte Value { get; set; }

        protected override void ProcessRecord()
        {
            this.Device.device.WriteAddressByte(this.Register, this.Value);
        }
    }

    [Cmdlet(VerbsCommon.Set, "GpioPin")]
    public class SetGpioPin : Cmdlet
    {
        [Parameter(Mandatory = true)]
        public int Pin { get; set; }

        [Parameter(Mandatory = true)]
        public bool Value { get; set; }

        protected override void ProcessRecord()
        {
            var pin = Unosquare.RaspberryIO.Pi.Gpio[this.Pin];
            pin.PinMode = Unosquare.RaspberryIO.Gpio.GpioPinDriveMode.Output;
            pin.Write(this.Value);
        }
    }

    [Cmdlet(VerbsCommon.Get, "GpioPin")]
    public class GetGpioPin : Cmdlet
    {
        [Parameter(Mandatory = false)]
        public int? Pin { get; set; }

        [Parameter(Mandatory = false)]
        public Unosquare.RaspberryIO.Gpio.GpioPinResistorPullMode? PullMode { get; set; }

        protected override void ProcessRecord()
        {
            if (this.Pin.HasValue)
            {
                var pin = Unosquare.RaspberryIO.Pi.Gpio[this.Pin.Value];
                pin.PinMode = Unosquare.RaspberryIO.Gpio.GpioPinDriveMode.Input;
                if (this.PullMode.HasValue)
                {
                    pin.InputPullMode = this.PullMode.Value;
                };
                bool value = pin.Read();
                WriteObject(value);
            }
            else
            {
                foreach (var pin in Unosquare.RaspberryIO.Pi.Gpio.Pins)
                {
                    WriteObject(pin);
                }
            }
        }
    }
}