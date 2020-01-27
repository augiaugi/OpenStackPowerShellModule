<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Volume

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=delete-metadata-item-detail#create-or-update-metadata-item

    .NOTES
#>
function Set-OSVolumeMetadata
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $Volume,

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

            foreach($Volume in $Volume)
            {
                $Volume = Get-OSObjectIdentifierer -Object $Volume -PropertyHint 'OS.Volume'

                $Metadata = Get-OSVolumeMetadata -Volume $Volume
                if($Metadata.PSobject.Properties.name -notcontains $Key)
                {
                    throw "Key [$Key] doeas not exists."
                }

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "set Volume [$Volume] metadata [$Key=$Value]"
                $BodyObject = [PSCustomObject]@{meta=[PSCustomObject]@{$Key=$Value}}
                Write-Output (Invoke-OSApiRequest -HTTPVerb Put -Type volumev3 -Uri "volumes/$Volume/metadata/$Key" -Property 'meta' -ObjectType 'OS.VolumeMetadata' -Body $BodyObject
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