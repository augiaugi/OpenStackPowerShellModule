<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Volume

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

    https://docs.openstack.org/api-ref/block-storage/v3/?expanded=list-accessible-volumes-with-details-detail#delete-a-snapshot-s-metadata

    .NOTES
#>
function Remove-OSVolumeSnapshotMetadata
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $VolumeSnapshot,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Key
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($VolumeSnapshot in $VolumeSnapshot)
            {
                $VolumeSnapshot = Get-OSObjectIdentifierer -Object $VolumeSnapshot -PropertyHint 'OS.VolumeSnapshot'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "remove VolumeSnapshot [$VolumeSnapshot] metadata [$Key]"
                Invoke-OSApiRequest -HTTPVerb Delete -Type volumev3 -Uri "snapshots/$VolumeSnapshot/metadata/$Key" -NoOutput
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