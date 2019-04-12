<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ImputObject

    .PARAMETER Server

    .PARAMETER Device

    Name of the device such as, /dev/vdb. Omit or set this parameter to null for auto-assignment, if supported. If you specify this parameter, the device must not exist in the guest operating system. Note that as of the 12.0.0 Liberty release, the Nova libvirt driver no longer honors a user-supplied device name. This is the same behavior as if the device name parameter is not supplied on the request.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=detach-interface-detail#attach-a-volume-to-an-instance

    .NOTES
#>
function Add-OSServerVolumeAttachment
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Volume')]
        $ImputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Server,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Device
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'

            foreach($ImputObject in $ImputObject)
            {
                $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Volume'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "add VolumeAttachment [$ImputObject] to Server [$Server]"

                if($Device)
                {
                    $Body = ([PSCustomObject]@{volumeAttachment=[PSCustomObject]@{volumeId=$ImputObject; device=$Device}})
                }
                else 
                {
                    $Body = ([PSCustomObject]@{volumeAttachment=[PSCustomObject]@{volumeId=$ImputObject}})
                }
                Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "servers/$Server/os-volume_attachments" -Property 'volumeAttachment' -ObjectType 'OS.ServerVolumeAttachment' -Body $Body
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