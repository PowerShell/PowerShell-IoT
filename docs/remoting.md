# SSH Remoting Docs

> NOTE: These docs were created while using a Raspberry Pi 3 with Raspbian Stretch.

## Prereqs

First you need to get the IP address of the device. You can do this by running this on the device:

```bash
PS > hostname -I

123.123.123.123 <ignore this extra stuff>
```

You also need to have [PowerShell Core](https://github.com/powershell/powershell) installed on your device.

You'll also need some SSH client. macOS and linux have it installed by default, for Windows, check out the [Win32 port of OpenSSH](https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH).

## Using pure SSH

First ssh into your pi:

```plaintext
> ssh pi@123.123.123.123

# At this point you are remoted into to the device and can start PowerShell

> sudo pwsh
PS > Get-GpioPin 1
```

## Using PowerShell Remoting (PSRP) over SSH

> NOTE: This will only work if your device doesn't require a password when you run `sudo pwsh`. The Raspberry Pi 3 with default configuration does not prompt.

First you need to install [PowerShell Core](https://github.com/powershell/powershell) on your client machine. Windows PowerShell does not support PowerShell Remoting (PSRP) over SSH so that will not work.

Second you need to set up PSRP over SSH. You can [follow this guide](https://github.com/PowerShell/PowerShell/blob/11631e7412197f3f803ebbef95a3ddb174a387ec/demos/SSHRemoting/README.md).

When you get to the part where it says:

> Add a PowerShell subsystem entry

Put this:

```plaintext
Subsystem powershell sudo pwsh -sshs -NoLogo -NoProfile
```

Note the use of `sudo`.

If done correctly, you should be able to run:

```powershell
PS > Enter-PSSession -Hostname 123.123.123.123 -UserName pi

# At this point you are remoted into to the device already in PowerShell

[123.123.123.123] PS > Get-GpioPin 1
```

By doing this, you should be able to automate working with your device using PowerShell 🎉
