<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Volume

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://docs.openstack.org/api-ref/block-storage/v3/?expanded=list-accessible-volumes-with-details-detail#create-a-snapshot-s-metadata

    .NOTES
#>
function New-OSVolumeSnapshotMetadata
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $VolumeSnapshot,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Key,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Value
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($VolumeSnapshot in $VolumeSnapshot)
            {
                $VolumeSnapshot = Get-OSObjectIdentifierer -Object $VolumeSnapshot -PropertyHint 'OS.VolumeSnapshot'

                $Metadata = Get-OSVolumeSnapshotMetadata -VolumeSnapshot $VolumeSnapshot
                if($Metadata.PSobject.Properties.name -contains $Key)
                {
                    throw "Key [$Key] already exists."
                }

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create VolumeSnapshot [$VolumeSnapshot] metadata [$Key=$Value]"
                $BodyObject = [PSCustomObject]@{meta=[PSCustomObject]@{$Key=$Value}}
                Write-Output (Invoke-OSApiRequest -HTTPVerb Put -Type volumev3 -Uri "snapshots/$VolumeSnapshot/metadata/$Key" -Property 'meta' -ObjectType 'OS.VolumeSnapshotMetadata' -Body $BodyObject
                )
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