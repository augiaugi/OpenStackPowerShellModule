<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Size

    The size of the volume, in gibibytes (GiB).

    .PARAMETER Name

    The volume name.

    .PARAMETER Description

    The volume description.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    New-OSVolume -Size 1 -Name 'OS_disk'

    .LINK

        https://developer.openstack.org/api-ref/block-storage/v3/#create-a-volume

    .NOTES
#>
function New-OSVolume
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [Parameter (ParameterSetName = 'Image', Mandatory = $true)]
        [Parameter (ParameterSetName = 'VolumeSnapshot', Mandatory = $true)]
        [Parameter (ParameterSetName = 'VolumeBackup', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$Size,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [Parameter (ParameterSetName = 'Image', Mandatory = $false)]
        [Parameter (ParameterSetName = 'VolumeSnapshot', Mandatory = $false)]
        [Parameter (ParameterSetName = 'VolumeBackup', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [Parameter (ParameterSetName = 'Image', Mandatory = $false)]
        [Parameter (ParameterSetName = 'VolumeSnapshot', Mandatory = $false)]
        [Parameter (ParameterSetName = 'VolumeBackup', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter (ParameterSetName = 'Image', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Image,

        [Parameter (ParameterSetName = 'VolumeSnapshot', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $VolumeSnapshot,

        [Parameter (ParameterSetName = 'VolumeBackup', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $VolumeBackup
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            $Properties = @{
                size=$Size
            }
            if($Name){$Properties.Add('name', $Name)}
            if($Description){$Properties.Add('description', $Description)}

            switch ($PsCmdlet.ParameterSetName)
            {
                'Default'
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Volume [$Size]"
      
                    $Body = [PSCustomObject]@{volume=$Properties}
                    Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type volumev3 -Uri "volumes" -Property 'volume' -ObjectType 'OS.CreateVolume' -Body $Body)
                }
                'Image'
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Volume [$Size], Image [$Image]"

                    $Image = Get-OSObjectIdentifierer -Object $Image -PropertyHint 'OS.Image'
                    $Properties.Add('imageRef', $Image)
                    $Body = [PSCustomObject]@{volume=$Properties}
                    Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type volumev3 -Uri "volumes" -Property 'volume' -ObjectType 'OS.CreateVolume' -Body $Body)
                }
                'VolumeSnapshot'
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Volume [$Size], VolumeSnapshot [$VolumeSnapshot]"

                    $VolumeSnapshot = Get-OSObjectIdentifierer -Object $VolumeSnapshot -PropertyHint 'OS.VolumeSnapshot'
                    $Properties.Add('snapshot_id', $VolumeSnapshot)
                    $Body = [PSCustomObject]@{volume=$Properties}
                    Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type volumev3 -Uri "volumes" -Property 'volume' -ObjectType 'OS.CreateVolume' -Body $Body)
                }
                'VolumeBackup'
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Volume [$Size], VolumeBackup [$VolumeBackup]"

                    $VolumeBackup = Get-OSObjectIdentifierer -Object $VolumeBackup -PropertyHint 'OS.VolumeBackup'
                    $Properties.Add('backup_id', $VolumeBackup)
                    $Body = [PSCustomObject]@{volume=$Properties}
                    Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type volumev3 -Uri "volumes" -Property 'volume' -ObjectType 'OS.CreateVolume' -Body $Body)
                }
                default
                {
                    throw "unexpected ParameterSetName [$ParameterSetName]"
                }
            }
        }
        catch
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type ERROR -Exception $_
            throw
        }
        finally
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message 'end'
        }
    }
}