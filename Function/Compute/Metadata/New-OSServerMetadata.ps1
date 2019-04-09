<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=delete-metadata-item-detail#create-or-update-metadata-item

    .NOTES
#>
function New-OSServerMetadata
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $Server,

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

            foreach($Server in $Server)
            {
                $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'

                $Metadata = Get-OSServerMetadata -Server $Server
                if($Metadata.PSobject.Properties.name -contains $Key)
                {
                    throw "Key [$Key] already exists."
                }

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Server [$Server] metadata [$Key=$Value]"
                $BodyObject = [PSCustomObject]@{meta=[PSCustomObject]@{$Key=$Value}}
                Write-Output (Invoke-OSApiRequest -HTTPVerb Put -Type compute -Uri "servers/$Server/metadata/$Key" -Property 'meta' -ObjectType 'OS.ServerMetadata' -Body $BodyObject
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