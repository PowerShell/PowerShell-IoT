using System;
using System.Management.Automation;  // PowerShell namespace.

[Cmdlet(VerbsCommon.Set, "I2CRegister")]
public class SetI2CRegister : Cmdlet
{
    [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
    public I2CDevice Device { get; set; }

    [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 1)]
    public ushort Register { get; set; }

    [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 2)]
    public byte[] Data { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true)]
    public SwitchParameter PassThru { get; set; }

    protected override void ProcessRecord()
    {
        Span<byte> dataOut = stackalloc byte[] { (byte)Register, Data[0] };
        this.Device.device.Write(dataOut);
        if (this.PassThru)
        {
            I2CDeviceRegisterData result = new I2CDeviceRegisterData(this.Device, this.Register, this.Data);
            WriteObject(result);
        }
    }
}