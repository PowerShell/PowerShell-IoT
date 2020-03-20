using System;
using System.Management.Automation;
using System.Device.Gpio;

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
			GpioController controller = new GpioController();
			//using (GpioController controller = new GpioController())
        	//{
				foreach (int pinId in this.Id)
				{
					controller.OpenPin(pinId, PinMode.Output); // pin will be closed in GpioController.Dispose()
					if(this.Value == SignalLevel.Low)
					{
						controller.Write(pinId, PinValue.Low);
					}
					else
					{
						controller.Write(pinId, PinValue.High);
					}

					if (this.PassThru)
					{
						GpioPinData pinData = new GpioPinData(pinId, this.Value);
						WriteObject(pinData);
					}
				}
			//}
		}
	}
}