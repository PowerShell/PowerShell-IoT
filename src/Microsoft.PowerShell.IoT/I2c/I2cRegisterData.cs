public class I2CDeviceRegisterData
{
    public I2CDevice Device { get; set; }
    public ushort Register { get; set; }
    public byte[] Data { get; set; }

    public I2CDeviceRegisterData(I2CDevice device, ushort register, byte[] data)
    {
        this.Device = device;
        this.Register = register;
        this.Data = data;
    }

    public I2CDeviceRegisterData(I2CDevice device, ushort register)
        : this(device, register, new byte[0])
    {
    }

    public I2CDeviceRegisterData()
        : this(null, 0)
    {
    }
}