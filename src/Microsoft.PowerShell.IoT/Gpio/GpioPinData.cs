 public class GpioPinData
{
    public int Id;
    public SignalLevel Value;

    public GpioPinData(int id, SignalLevel value)
    {
        this.Id = id;
        this.Value = value;
    }
}

public enum SignalLevel
{
    Low = 0,
    High = 1
}