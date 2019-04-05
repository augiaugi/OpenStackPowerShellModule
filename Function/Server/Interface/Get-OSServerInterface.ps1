<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=#list-port-interfaces

    .NOTES
#>
function Get-OSServerInterface
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $Server
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($Server in $Server)
            {
                $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Server [$Server] Interfaces"
                Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/$Server/os-interface" -Property 'interfaceAttachments' -ObjectType 'OS.ServerInterface')       
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