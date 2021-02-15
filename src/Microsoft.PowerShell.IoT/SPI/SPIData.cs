// public class SPIData
// {
//     public int BusId { get; set; }
//     public int ChipSelectLine { get; set; }
//     public int Frequency { get; set; }
//     public byte[] Data { get; set; }
//     public byte[] Response { get; set; }

//     public SPIData(int busId, int chipSelectLine, int frequency, byte[] data, byte[] response)
//     {
//         this.BusId = busId;
//         this.ChipSelectLine = chipSelectLine;
//         this.Frequency = frequency;
//         this.Data = data;
//         this.Response = response;
//     }
// }

using System.Device.Gpio;
using System.Device.Spi;

public class SPIData : SPIDevice
{
    public byte[] Data { get; set; }
    public byte[] Response { get; set; }
    public SPIData(SpiDevice device, int busId, int chipSelectLine, int frequency, 
                   int dataBitLength, SpiMode mode, DataFlow dataFlow, 
                   PinValue chipSelectLineActiveState, byte[] data, byte[] response
                  ): base(device, busId, chipSelectLine, frequency, dataBitLength, mode, dataFlow, chipSelectLineActiveState)
    {
        this.Data = data;
        this.Response = response;
    }
}
