public class I2CDevice
{
	internal Unosquare.RaspberryIO.Gpio.I2CDevice device = null;
	internal System.Device.I2c.I2cDevice device_v2 = null;

	public string FriendlyName { get; set; }
	public int Id { get; set; }

	public I2CDevice(Unosquare.RaspberryIO.Gpio.I2CDevice device, int Id, string FriendlyName)
	{
		this.device = device;
		this.Id = Id;
		this.FriendlyName = FriendlyName;
	}

	public override string ToString()
	{
		if (string.IsNullOrEmpty(this.FriendlyName))
		{
			return this.Id.ToString();
		}
		else
		{
			return this.FriendlyName;
		}
	}
}