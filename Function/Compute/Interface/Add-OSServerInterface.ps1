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
function Add-OSServerInterface
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $Port,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Server
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            foreach($Server in $Server)
            {
                $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'

                foreach($Port in $Port)
                {
                    $Port = Get-OSObjectIdentifierer -Object $Port -PropertyHint 'OS.Port'

                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "add Interface [$Port] to Server [$Server]"
                    Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "servers/$Server/os-interface" -Property 'interfaceAttachment' -ObjectType 'OS.ServerInterface' -Body ([PSCustomObject]@{interfaceAttachment=[PSCustomObject]@{port_id=$Port}})
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