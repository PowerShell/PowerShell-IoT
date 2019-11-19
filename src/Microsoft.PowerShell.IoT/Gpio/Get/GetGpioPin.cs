using System;
using System.Collections;
using System.Management.Automation;  // PowerShell namespace.

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
		try
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

			foreach (int pinId in pinList)
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

 public enum PullMode
{
	Off = 0,
	PullDown = 1,
	PullUp = 2
}