public class I2CDevice
{
    internal System.Device.I2c.I2cDevice device = null;

    public string FriendlyName { get; set; }
    public int Id { get; set; }
    public int BusId { get; set; }

    public I2CDevice(System.Device.I2c.I2cDevice device, int Id, string FriendlyName, int BusId)
    {
        this.device = device;
        this.Id = Id;
        this.FriendlyName = FriendlyName;
        this.BusId = BusId;
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
