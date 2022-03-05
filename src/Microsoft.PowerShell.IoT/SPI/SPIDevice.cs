using System.Device.Gpio;
using System.Device.Spi;

public class SPIDevice
{
    internal SpiDevice device = null;
    public int BusId { get; set; }

    public int ChipSelectLine { get; set; }

    public int Frequency { get; set; }

    public int DataBitLength { get; set;}

    public SpiMode Mode { get; set; }

    public DataFlow DataFlow { get; set; }

    public PinValue ChipSelectLineActiveState { get; set; }

    public SPIDevice(SpiDevice device, int busId, int chipSelectLine, int frequency, 
                     int dataBitLength, SpiMode mode, DataFlow dataFlow, 
                     PinValue chipSelectLineActiveState)
    {
        this.device = device;
        this.BusId = busId;
        this.ChipSelectLine = chipSelectLine;
        this.Frequency = frequency;
        this.DataBitLength = dataBitLength;
        this.Mode = mode;
        this.DataFlow = dataFlow;
        this.ChipSelectLineActiveState = chipSelectLineActiveState;        
    }
}
