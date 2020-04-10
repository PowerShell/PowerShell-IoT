using System;
using System.Management.Automation;
using System.Device.Gpio;

public class GpioCmdletBase : Cmdlet
{
    protected static GpioController StaticGpioController;
    protected GpioController GpioController
    {
        get
        {
            if (StaticGpioController == null)
            {
                StaticGpioController = new GpioController();
            }
            return StaticGpioController;
        }
        set
        {
            StaticGpioController = value;
        }
    }

    protected void EnsureOpenPin(int pinId, PinMode mode)
    {
        if (this.GpioController.IsPinOpen(pinId))
        {
            if (this.GpioController.GetPinMode(pinId) != mode)
            {
                this.GpioController.SetPinMode(pinId, mode);
            }
        }
        else
        {
            this.GpioController.OpenPin(pinId, mode);
        }
    }
}

[Cmdlet(VerbsCommon.Clear, "GpioResources")]
public class ClearGpioResources : GpioCmdletBase
{
    protected override void ProcessRecord()
    {
        if (GpioCmdletBase.StaticGpioController != null)
        {
            GpioCmdletBase.StaticGpioController.Dispose();
            GpioCmdletBase.StaticGpioController = null;
        }
    }
}
