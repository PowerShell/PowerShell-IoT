using System;
using System.Collections;
using System.Management.Automation;
using System.Device.Gpio;

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
			// this is "gpio readall" functionality

			/*foreach (var pin in Unosquare.RaspberryIO.Pi.Gpio.Pins)
			{
				pinList.Add(pin.PinNumber);
			}*/
		}
		else
		{
			pinList.AddRange(this.Id);
		}

		using (GpioController controller = new GpioController())
        {
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
				controller.OpenPin(pinId, mode); // pin will be closed in GpioController.Dispose()
				if (controller.Read(pinId) == PinValue.High)
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
}

 public enum PullMode
{
	Off = 0,
	PullDown = 1,
	PullUp = 2
}