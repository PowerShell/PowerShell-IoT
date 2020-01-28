using System;
using System.Management.Automation;  // PowerShell namespace.
using System.Device.Gpio;
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
		//SpiDevice dev = new SpiDevice();
		this.Channel = 0;
		this.Frequency = Unosquare.RaspberryIO.Gpio.SpiChannel.MinFrequency;
	}

	protected override void ProcessRecord()
	{
		try
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

			var response = spiChannel.SendReceive(this.Data);
			if (this.Raw)
			{
				WriteObject(response);
			}
			else
			{
				SPIData spiData = new SPIData(this.Channel, this.Frequency, this.Data, response);
				WriteObject(spiData);
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