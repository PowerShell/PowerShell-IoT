using System;
using System.Management.Automation;
using System.Device.Spi;
using System.Device.Gpio;

[Cmdlet(VerbsCommunications.Send, "SPIData")]
public class SendSPIData : Cmdlet
{
    [Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
    public byte[] Data { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 1)]
    public int BusId { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 2)]
    public int ChipSelectLine { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 3)]
    public int Frequency { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 4)]
    public int DataBitLength { get; set;}

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 5)]
    public SpiMode Mode { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 6)]
    public DataFlow DataFlow { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true, Position = 7)]
    public PinValue ChipSelectLineActiveState { get; set; }

    [Parameter(Mandatory = false, ValueFromPipelineByPropertyName = true)]
    public SwitchParameter Raw { get; set; }

    public SendSPIData()
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

        using (var spiDevice = SpiDevice.Create(settings))
        {
            var response = new byte[this.Data.Length];

            spiDevice.TransferFullDuplex(this.Data, response);

            if (this.Raw)
            {
                WriteObject(response);
            }
            else
            {
                SPIData spiData = new SPIData(spiDevice, this.BusId, this.ChipSelectLine, this.Frequency, 
                                                  this.DataBitLength, this.Mode, this.DataFlow, 
                                                  this.ChipSelectLineActiveState, this.Data, response);
                //SPIData spiData = new SPIData(this.BusId, this.ChipSelectLine, this.Frequency, this.Data, response);
                WriteObject(spiData);
            }
        }
    }
}
