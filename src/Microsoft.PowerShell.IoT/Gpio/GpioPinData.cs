 public class GpioPinData
{
	public int Id;
	public SignalLevel Value;
	//public Unosquare.RaspberryIO.Gpio.GpioPin PinInfo; //not in use

	public GpioPinData(int id, SignalLevel value, Unosquare.RaspberryIO.Gpio.GpioPin pinInfo)
	{
		this.Id = id;
		this.Value = value;
		//this.PinInfo = pinInfo;
	}
}

public enum SignalLevel
{
	Low = 0,
	High = 1
}