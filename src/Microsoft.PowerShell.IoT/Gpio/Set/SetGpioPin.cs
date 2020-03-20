using System;
using System.Management.Automation;  // PowerShell namespace.

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
		try
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
		catch (System.TypeInitializationException e) // Unosquare.RaspberryIO.Gpio.GpioController.Initialize throws this TypeInitializationException
		{
			if (!Unosquare.RaspberryIO.Computer.SystemInfo.Instance.IsRunningAsRoot)
			{
				throw new PlatformNotSupportedException(Resources.ErrNeedRootPrivileges, e);
			}
			throw;
		}
	}
}