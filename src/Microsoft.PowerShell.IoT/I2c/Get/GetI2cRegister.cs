using System;
using System.Management.Automation;  // PowerShell namespace.
[Cmdlet(VerbsCommon.Get, "I2CRegister")]
public class GetI2CRegister : Cmdlet
{
	[Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
	public I2CDevice Device { get; set; }

	[Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 1)]
	public ushort Register { get; set; }

	[Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 2)]
	public byte ByteCount { get; set; }

	[Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true)]
	public SwitchParameter Raw { get; set; }

	public GetI2CRegister()
	{
		this.ByteCount = 1;
		this.Raw = false;
	}

	protected override void ProcessRecord()
	{
		try
		{
			if (this.ByteCount > 1)
			{
				this.Device.device.Write((byte)this.Register);
				byte[] value = this.Device.device.Read(this.ByteCount);
				if (this.Raw)
				{
					WriteObject(value);
				}
				else
				{
					I2CDeviceRegisterData result = new I2CDeviceRegisterData(this.Device, this.Register);
					result.Data = value;
					WriteObject(result);
				}
			}
			else
			{
				byte value = this.Device.device.ReadAddressByte(this.Register);
				if (this.Raw)
				{
					WriteObject(value);
				}
				else
				{
					I2CDeviceRegisterData result = new I2CDeviceRegisterData(this.Device, this.Register, new byte[1] { value });
					WriteObject(result);
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