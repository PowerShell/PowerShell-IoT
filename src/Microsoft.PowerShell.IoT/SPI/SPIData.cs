 public class SPIData
{
	public uint Channel { get; set; }
	public uint Frequency { get; set; }
	public byte[] Data { get; set; }
	public byte[] Response { get; set; }

	public SPIData(uint channel, uint frequency, byte[] data, byte[] response)
	{
		this.Channel = channel;
		this.Frequency = frequency;
		this.Data = data;
		this.Response = response;
	}
}