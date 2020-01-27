<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Volume

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://docs.openstack.org/api-ref/block-storage/v3/?expanded=list-accessible-volumes-with-details-detail#show-a-snapshot-s-metadata

    .NOTES
#>
function Get-OSVolumeSnapshotMetadata
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $VolumeSnapshot,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
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

                if($Key)
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get VolumeSnapshot [$VolumeSnapshot] metadata [$Key]"
                    Write-Output (Invoke-OSApiRequest -Type volumev3 -Uri "snapshots/$VolumeSnapshot/metadata/$Key" -Property 'meta' -ObjectType 'OS.VolumeSnapshotMetadata')
                }
                else 
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get VolumeSnapshot [$VolumeSnapshot] metadata"
                    Write-Output (Invoke-OSApiRequest -Type volumev3 -Uri "snapshots/$VolumeSnapshot/metadata" -Property 'metadata' -ObjectType 'OS.VolumeSnapshotMetadata')       
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