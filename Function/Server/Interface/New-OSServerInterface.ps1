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
        $Server,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$IPAddress,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Network
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            foreach($Server in $Server)
            {
                $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'
                $Network = Get-OSObjectIdentifierer -Object $Network -PropertyHint 'OS.Network'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "add new Interface [$IPAddress] to Server [$Server], Network [$Network]"

                $Body = [PSCustomObject]@{interfaceAttachment=[PSCustomObject]@{
                    net_id=$Network
                    fixed_ips=@()
                }}
                foreach($IPAddressItem in $IPAddress)
                {
                    $Body.interfaceAttachment.fixed_ips += [PSCustomObject]@{ip_address=$IPAddressItem}
                }

                Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "servers/$Server/os-interface" -Property 'interfaceAttachment' -ObjectType 'OS.ServerInterface' -Body $Body
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