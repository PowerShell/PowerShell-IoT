# VSTS task states: Succeeded|SucceededWithIssues|Failed|Cancelled|Skipped
$succeededStateName = 'Succeeded'
$warningStateName = 'SucceededWithIssues'
$errorStateName = 'Failed'

# store the current state used by *-VstsTaskState and Write-VstsMessage
$script:taskstate = $succeededStateName

function Clear-VstsTaskState
{
    $script:taskstate = $succeededStateName
}

function Get-TempFolder
{
    $tempPath = [System.IO.Path]::GetTempPath()
    # Use the agent temp on VSTS which is cleanup between builds (the user temp is not)
    if($env:AGENT_TEMPDIRECTORY)
    {
        $tempPath = $env:AGENT_TEMPDIRECTORY
    }

    $tempFolder = Join-Path -Path $tempPath -ChildPath ([System.IO.Path]::GetRandomFileName())
    if(!(test-path $tempFolder))
    {
        $null = New-Item -Path $tempFolder -ItemType Directory
    }

    return $tempFolder
}

$script:AlternateStagingDirectory = $null
function Get-StagingDirectory
{
    # environment variable are documented here:
    # https://docs.microsoft.com/en-us/vsts/build-release/concepts/definitions/build/variables?tabs=batch
    if($env:BUILD_STAGINGDIRECTORY)
    {
        return $env:BUILD_STAGINGDIRECTORY
    }
    else {
        if(!$script:AlternateStagingDirectory)
        {
            Write-VstsInformation "Cannot find staging directory, logging environment"
            Get-ChildItem env: | ForEach-Object { Write-VstsInformation -message $_}
            $script:AlternateStagingDirectory = Get-TempFolder
        }
        return $script:AlternateStagingDirectory
    }
}

$script:publishedFiles = @()
# Publishes build artifacts
function Publish-VstsBuildArtifact
{
    param(
        [parameter(Mandatory,HelpMessage="Path to publish artifacts from.")]
        [string]$ArtifactPath,
        [parameter(HelpMessage="The folder to same artifacts to.")]
        [string]$Bucket = 'release',
        [parameter(HelpMessage="If an artifact is unzipped, set a variable to the destination path with this name. Only supported with '-ExpectedCount 1'")]
        [string]$Variable,
        [parameter(HelpMessage="Expected Artifact Count. Will throw if the count does not match. Not specified or -1 will ignore this parameter.")]
        [int]$ExpectedCount = -1
    )
    $ErrorActionPreference = 'Continue'
    Write-VstsInformation -message "Publishing artifacts: $ArtifactPath"

    # In VSTS, publish artifacts appropriately
    $files = Get-Item -Path $ArtifactPath | Select-Object -ExpandProperty FullName
    $destinationPath = Join-Path (Get-StagingDirectory) -ChildPath $Bucket
    if(-not (Test-Path $destinationPath))
    {
        $null = New-Item -Path $destinationPath -ItemType Directory
    }

    foreach($fileName in $files)
    {
        # Only publish files once
        if($script:publishedFiles -inotcontains $fileName)
        {
            $leafFileName = $(Split-path -Path $fileName -Leaf)

            $extension = [System.IO.Path]::GetExtension($leafFileName)
            $nameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($leafFileName)
            # Only expand the symbol '.zip' package
            if($extension -ieq '.zip' -and $nameWithoutExtension.Contains("symbols"))
            {
                $unzipPath = (Join-Path $destinationPath -ChildPath $nameWithoutExtension)
                if($Variable)
                {
                    Write-VstsInformation -message "Setting VSTS variable '$Variable' to '$unzipPath'"
                    # Sets a VSTS variable for use in future build steps.
                    Write-Host "##vso[task.setvariable variable=$Variable]$unzipPath"
                    # Set a variable in the current process. PowerShell will not pickup the variable until the process is restarted otherwise.
                    Set-Item env:\$Variable -Value $unzipPath
                }
                Expand-Archive -Path $fileName -DestinationPath $unzipPath
            }

            Write-Host "##vso[artifact.upload containerfolder=$Bucket;artifactname=$Bucket]$fileName"
            $script:publishedFiles += $fileName
        }
    }

    if($ExpectedCount -ne -1 -and $files.Count -ne $ExpectedCount)
    {
        throw "Build did not produce the expected number of binaries. $($files.count) were produced instead of $ExpectedCount."
    }
}

function Write-VstsError {
    param(
        [Parameter(Mandatory=$true)]
        [Object]
        $Error,
        [ValidateSet("error","warning")]
        $Type = 'error'
    )

    $message = [string]::Empty
    $errorType = $Error.GetType().FullName
    $newLine = [System.Environment]::NewLine
    switch($errorType)
    {
        'System.Management.Automation.ErrorRecord'{
            $message = "{0}{2}`t{1}" -f $Error,$Error.ScriptStackTrace,$newLine
        }
        'System.Management.Automation.ParseException'{
            $message = "{0}{2}`t{1}" -f $Error,$Error.StackTrace,$newLine
        }
        'System.Management.Automation.Runspaces.RemotingErrorRecord'
        {
            $message = "{0}{2}`t{1}{2}`tOrigin: {2}" -f $Error,$Error.ScriptStackTrace,$Error.OriginInfo,$newLine
        }
        default
        {
            # Log any unknown error types we get so  we can improve logging.
            log "errorType: $errorType"
            $message =  $Error.ToString()
        }
    }
    $message.Split($newLine) | ForEach-Object {
        Write-VstsMessage -type $Type -message $PSItem
    }
}

# Log messages which potentially change job status
function Write-VstsMessage {
    param(
        [ValidateSet("error","warning")]
        $type = 'error',
        [String]
        $message
    )

    if($script:taskstate -ne $errorStateName -and $type -eq 'error')
    {
        $script:taskstate = $errorStateName
    }
    elseif($script:taskstate -eq $succeededStateName) {
        $script:taskstate = $warningStateName
    }

    # See VSTS documentation at https://github.com/Microsoft/vsts-tasks/blob/master/docs/authoring/commands.md
    # Log task message
    Write-Host "##vso[task.logissue type=$type]$message"
}

# Log informational messages
function Write-VstsInformation {
    param(
        [String]
        $message
    )

    Write-Host $message
}

function Write-VstsTaskState
{
    # See VSTS documentation at https://github.com/Microsoft/vsts-tasks/blob/master/docs/authoring/commands.md
    # Log task state
    Write-Host "##vso[task.complete result=$script:taskstate;]DONE"
}

Export-ModuleMember @(
    'Publish-VstsBuildArtifact'
    'Write-VstsError'
    'Write-VstsMessage'
    'Clear-VstsTaskState'
    'Write-VstsTaskState'
)