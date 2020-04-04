using System;
using System.Management.Automation;
using System.Device.Gpio;

[Cmdlet(VerbsCommon.Set, "GpioPin")]
public class SetGpioPin : GpioCmdletBase
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
                if (this.GpioController.IsPinOpen(pinId))
                {
                    if (this.GpioController.GetPinMode(pinId) != PinMode.Output)
                    {
                        this.GpioController.SetPinMode(pinId, PinMode.Output);
                    }
                }
                else
                {
                    this.GpioController.OpenPin(pinId, PinMode.Output);
                }
                
                if(this.Value == SignalLevel.Low)
                {
                    this.GpioController.Write(pinId, PinValue.Low);
                }
                else
                {
                    this.GpioController.Write(pinId, PinValue.High);
                }

                if (this.PassThru)
                {
                    GpioPinData pinData = new GpioPinData(pinId, this.Value);
                    WriteObject(pinData);
                }
            }
        }
    }
}