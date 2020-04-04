using System;
using System.Management.Automation;
using System.Device.I2c;

[Cmdlet(VerbsCommon.Get, "I2CDevice")]
public class GetI2CDevice : Cmdlet
{
    [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0)]
    public int Id { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 1)]
    public string FriendlyName { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 2)]
    public int BusId { get; set; }

    public GetI2CDevice()
    {
        this.FriendlyName = string.Empty;
        this.Id = 0;
        this.BusId = 1;
    }

    protected override void ProcessRecord()
    {
        var settings = new I2cConnectionSettings(this.BusId, this.Id);
        I2cDevice device = I2cDevice.Create(settings);
        WriteObject(new I2CDevice(device, this.Id, this.FriendlyName, this.BusId));
    }
}