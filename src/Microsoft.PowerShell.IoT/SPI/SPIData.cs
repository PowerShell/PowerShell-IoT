public class SPIData
{
    public int BusId { get; set; }
    public int ChipSelectLine { get; set; }
    public int Frequency { get; set; }
    public byte[] Data { get; set; }
    public byte[] Response { get; set; }

    public SPIData(int busId, int chipSelectLine, int frequency, byte[] data, byte[] response)
    {
        this.BusId = busId;
        this.ChipSelectLine = chipSelectLine;
        this.Frequency = frequency;
        this.Data = data;
        this.Response = response;
    }
}
