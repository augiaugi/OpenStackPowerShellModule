<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=detach-interface-detail#detach-a-volume-from-an-instance

    .NOTES
#>
function Remove-OSServerVolumeAttachment
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $Server,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Volume
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($Server in $Server)
            {
                $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'

                foreach($Volume in $Volume)
                {
                    $Volume = Get-OSObjectIdentifierer -Object $Volume -PropertyHint 'OS.Volume'

                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "remove Server [$Server] Volume [$Volume]"
                    Invoke-OSApiRequest -HTTPVerb Delete -Type compute -Uri "servers/$Server/os-volume_attachments/$Volume" -NoOutput
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