using System;
using System.Management.Automation;  // PowerShell namespace.

[Cmdlet(VerbsCommon.Get, "I2CDevice")]
public class GetI2CDevice : Cmdlet
{
	[Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0)]
	public int Id { get; set; }

	[Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 1)]
	public string FriendlyName { get; set; }

	public GetI2CDevice()
	{
		this.FriendlyName = string.Empty;
		this.Id = 0;
	}

	protected override void ProcessRecord()
	{
		try
		{
			WriteObject(new I2CDevice(Unosquare.RaspberryIO.Pi.I2C.AddDevice(this.Id), this.Id, this.FriendlyName));
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