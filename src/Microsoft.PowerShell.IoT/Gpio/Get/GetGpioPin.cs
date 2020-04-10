using System;
using System.Collections;
using System.Management.Automation;
using System.Device.Gpio;

[Cmdlet(VerbsCommon.Get, "GpioPin")]
public class GetGpioPin : GpioCmdletBase
{
    [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
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
            // TODO: this is "gpio readall" functionality
            // do not forget to change Id param to Mandatory = false when this is implemented
        }
        else
        {
            pinList.AddRange(this.Id);
        }
        
        PinMode mode = PinMode.Input;
        if (this.PullMode.HasValue)
        {
            switch (this.PullMode.Value)
            {
                case global::PullMode.PullDown: mode = PinMode.InputPullDown; break;
                case global::PullMode.PullUp:   mode = PinMode.InputPullUp; break;
                default:                        mode = PinMode.Input; break;
            };
        };

        foreach (int pinId in pinList)
        {
            SignalLevel slResult = SignalLevel.Low;

            this.EnsureOpenPin(pinId, mode);

            if (this.GpioController.Read(pinId) == PinValue.High)
            {
                slResult = SignalLevel.High;
            };
            
            if (this.Raw)
            {
                WriteObject(slResult);
            }
            else
            {
                GpioPinData pinData = new GpioPinData(pinId, slResult);
                WriteObject(pinData);
            }
        }
    }
}

 public enum PullMode
{
    Off = 0,
    PullDown = 1,
    PullUp = 2
}
