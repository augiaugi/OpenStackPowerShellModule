<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ImputObject

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=detach-interface-detail#list-volume-attachments-for-an-instance

    .NOTES
#>
function Get-OSServerVolumeAttachment
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Server')]
        $ImputObject
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($ImputObject in $ImputObject)
            {
                $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Server'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Server [$ImputObject] VolumeAttachment"
                Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/$ImputObject/os-volume_attachments" -Property 'volumeAttachments' -ObjectType 'OS.ServerVolumeAttachment')       
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