using System;
using System.Management.Automation;
using System.Device.Spi;

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
        var settings = new SpiConnectionSettings(this.BusId, this.ChipSelectLine);
        settings.ClockFrequency = this.Frequency;
        
        using(var spiDevice = SpiDevice.Create(settings))
        {
            var response = new byte[this.Data.Length];

            spiDevice.TransferFullDuplex(this.Data, response);

            if (this.Raw)
            {
                WriteObject(response);
            }
            else
            {
                SPIData spiData = new SPIData(this.BusId, this.ChipSelectLine, this.Frequency, this.Data, response);
                WriteObject(spiData);
            }
        }
    }
}
