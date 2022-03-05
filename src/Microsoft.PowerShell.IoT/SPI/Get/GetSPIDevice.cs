using System;
using System.Management.Automation;
using System.Device.Spi;
using System.Device.Gpio;

[Cmdlet(VerbsCommon.Get, "SPIDevice")]
public class GetSPIDevice : Cmdlet
{

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 0)]
    public int BusId { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 1)]
    public int ChipSelectLine { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 2)]
    public int Frequency { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 3)]
    public int DataBitLength { get; set;}

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 4)]
    public SpiMode Mode { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 5)]
    public DataFlow DataFlow { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 6)]
    public PinValue ChipSelectLineActiveState { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true)]
    public SwitchParameter Raw { get; set; }

    public GetSPIDevice()
    {
        this.BusId = 0;
        this.ChipSelectLine = 0;
        this.Frequency = 500_000; // 500 KHz default speed
    }

    protected override void ProcessRecord()
    {
        var settings = new SpiConnectionSettings(this.BusId, this.ChipSelectLine)
        {
            ClockFrequency = this.Frequency,
            DataBitLength = this.DataBitLength,
            Mode = this.Mode,
            DataFlow = this.DataFlow,
            ChipSelectLineActiveState = this.ChipSelectLineActiveState
        };

        SpiDevice spiDevice = SpiDevice.Create(settings);
        //TODO: This can be done this way if we follow the same logic as in I2C where we access the device by doing device.Device
        // WriteObject(new SPIDevice(spiDevice, this.BusId, this.ChipSelectLine, this.Frequency, 
        //                             this.DataBitLength, this.Mode, this.DataFlow, 
        //                             this.ChipSelectLineActiveState));
        //Because I'm currently testing this like this : $device = Get-SPIDevice -Frequency 2400000 -Mode Mode0 -DataBitLength 8 -BusId 0 -ChipSelectLine 0
        // I want the returned object to be the spiDevice created.
        WriteObject(spiDevice);
        
    }
}
