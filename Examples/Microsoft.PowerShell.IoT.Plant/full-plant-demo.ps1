# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# A demo that uses Jobs to toggle lights and turn on the pump

Import-Module Microsoft.PowerShell.IoT.Plant

$lightjob = Start-Job {
    Import-Module Microsoft.PowerShell.IoT.Plant

    # start with lights off
    Set-Light Off
    $lightsOn = $false

    while ($true) {
        # toggle lights
        $lightsOn = -not $lightsOn
        if ($lightsOn) {
		Set-Light On
	} else {
		Set-Light Off
	}

        # wait some amount of time before toggling again
        Start-Sleep -s 20
    }
}

$waterJob = Start-Job {
    Import-Module Microsoft.PowerShell.IoT.Plant

    # start with water off
    Stop-Water

    while ($true) {

        if (Read-SoilIsDry) {

            # turn on the water for some amount of time
            Start-Water
            Start-Sleep -s 20
            Stop-Water

            # wait some amount of time before checking again
            Start-Sleep -s 20
        }

        # check sensor every 10 seconds
        Start-Sleep -s 10
    }
}

# clean up
Start-Sleep -s 120
Stop-Job $lightJob
Stop-Job $waterJob

Stop-Water
Set-Light Off
