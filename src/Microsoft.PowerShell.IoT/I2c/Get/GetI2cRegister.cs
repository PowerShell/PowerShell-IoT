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
        if (this.ByteCount > 1)
        {
            Span<byte> readBuffer = stackalloc byte[ByteCount];

            this.Device.device.WriteByte((byte)this.Register);
            this.Device.device.Read(readBuffer);

            if (this.Raw)
            {
                WriteObject(readBuffer.ToArray());
            }
            else
            {
                I2CDeviceRegisterData result = new I2CDeviceRegisterData(this.Device, this.Register)
                {
                    Data = readBuffer.ToArray() // optimize to be Span? How does PowerShell deal with it?
                };
                WriteObject(result);
            }
        }
        else
        {
            this.Device.device.WriteByte((byte)this.Register);
            byte value = this.Device.device.ReadByte();
            //byte value = this.Device.device.ReadAddressByte(this.Register);
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
}
