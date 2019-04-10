<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=#detach-interface

    .NOTES
#>
function Remove-OSServerInterface
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $Server,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Port
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($Server in $Server)
            {
                $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'

                foreach($Port in $Port)
                {
                    $Port = Get-OSObjectIdentifierer -Object $Port -PropertyHint 'OS.Port'

                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "remove Server [$Server] Port [$Port]"
                    Invoke-OSApiRequest -HTTPVerb Delete -Type compute -Uri "servers/$Server/os-interface/$Port" -NoOutput
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