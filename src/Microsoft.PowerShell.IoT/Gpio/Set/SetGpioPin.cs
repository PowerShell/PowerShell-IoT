using System;
using System.Management.Automation;  // PowerShell namespace.
using System.Device.Gpio;

[Cmdlet(VerbsCommon.Set, "GpioPin")]
public class SetGpioPin : Cmdlet
{
	[Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
	public GpioController Controller { get; set; }

	[Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
	public int[] Id { get; set; }

	[Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 2)]
	public SignalLevel Value { get; set; }

	[Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true)]
	public SwitchParameter PassThru { get; set; }

	protected override void ProcessRecord()
	{
		if (this.Id != null)
		{
			foreach (int pinId in this.Id)
			{
				/*
					This is try/finally is required because the user might try to write to a pin which he can't (for example 18).
					In that case it will throw an exception, and the pin would stay open, forcing the user to manually close it.
				*/
				try
				{
					if(!Controller.IsPinOpen(pinId))
					{
						Console.WriteLine("Pin was not open, opening it");
						Controller.OpenPin(pinId, PinMode.Output);
					}
					// Should we avoid the exception of Controller.Write, or should we deal with it ?
					// if(!Controller.GetPinMode(pinId) == PinMode.Output)
					// {
					// 	Console.WriteLine("You can't write to a pin that's not output")
					// }
					Controller.Write(pinId, Value == SignalLevel.High ? PinValue.High : PinValue.Low);
					if (this.PassThru)
					{
						GpioPinData pinData = new GpioPinData(pinId, this.Value);
						WriteObject(pinData);
					}
				}
				//TODO: How will we deal with exceptions?
				finally
				{
					Controller.ClosePin(pinId);
				}
			}
		}
	}
}