using System;
using System.Collections;
using System.Device.Gpio;
using System.Management.Automation;  // PowerShell namespace.

 [Cmdlet(VerbsCommon.Get, "GpioPin")]
public class GetGpioPin : Cmdlet
{
	[Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
	public GpioController Controller { get; set; }

	[Parameter(Mandatory = false, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
	public int[] Id { get; set; }

	[Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 2)]
	public PinMode? PinMode { get; set; }

	[Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true)]
	public SwitchParameter Raw { get; set; }

	protected override void ProcessRecord()
	{
		int[] allPins = new int[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 };

		ArrayList pinList = new ArrayList();

		if ((this.Id == null) || (this.Id.Length <= 0))
		{
			pinList.AddRange(allPins);
		}
		else
		{
			pinList.AddRange(this.Id);
		}

		foreach (int pinId in pinList)
		{
			//var pin = Unosquare.RaspberryIO.Pi.Gpio[pinId];
			Controller.OpenPin(pinId);

			try
			{
				if (this.PinMode.HasValue)
				{
					Controller.SetPinMode(pinId, PinMode.Value);
					//pin.InputPullMode = (Unosquare.RaspberryIO.Gpio.GpioPinResistorPullMode)this.PullMode.Value;
				};
			}
			catch (System.NotSupportedException)
			{
				// We want to avoid errors like
				// System.NotSupportedException : Get - GpioPin : Pin Pin15 'BCM 14 (UART Transmit)' does not support mode 'Input'.Pin capabilities are limited to: UARTTXD
				// at the same time we need to return PinInfo for such pins, so we need to continue processing
			}
			PinValue pinValue = Controller.Read(pinId);

			if (this.Raw)
			{
				WriteObject(pinValue); //test!
			}
			else
			{
				GpioPinData pinData = new GpioPinData(pinId, pinValue == PinValue.High ? SignalLevel.High : SignalLevel.Low);
				WriteObject(pinData);
			}
			Controller.ClosePin(pinId);
		}
	}
}