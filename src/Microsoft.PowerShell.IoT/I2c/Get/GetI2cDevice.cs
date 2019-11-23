using System;
using System.Management.Automation;  // PowerShell namespace.
using System.Device.I2c;

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
		var settings = new I2cConnectionSettings(1, this.Id);
		I2cDevice device = I2cDevice.Create(settings);
		WriteObject(new I2CDevice(device, this.Id, this.FriendlyName));

	}
}