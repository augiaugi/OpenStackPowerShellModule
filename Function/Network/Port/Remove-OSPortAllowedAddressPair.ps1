<#
    .SYNOPSIS

    .DESCRIPTION

    A set of zero or more allowed address pair objects each where address pair object contains an ip_address and mac_address. While the ip_address is required, the mac_address will be taken from the port if not specified. The value of ip_address can be an IP Address or a CIDR (if supported by the underlying extension plugin). A server connected to the port can send a packet with source address which matches one of the specified allowed address pairs.

    .PARAMETER ImputObject

    .PARAMETER IpAddress

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/#update-port

    .NOTES
#>
function Remove-OSPortAllowedAddressPair
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Port')]
        $ImputObject,
    
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$IpAddress
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($ImputObject in $ImputObject)
            {
                $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Port'

                $Port = $ImputObject | Get-OSPort

                if($Port.allowed_address_pairs.ip_address -notcontains $IpAddress)
                {
                    throw "AllowedAddressPair does not contains IpAddress [$IpAddress]."
                }

                $AllowedAddressPair = @($Port.allowed_address_pairs | ?{$_.ip_address -ne $IpAddress})
                $BodyObject = [PSCustomObject]@{port=[PSCustomObject]@{allowed_address_pairs=$AllowedAddressPair}}

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "add AllowedAddressPair [$IpAddress] to Port [$ImputObject], MacAddress [$MacAddress]"
                
                Write-Output (Invoke-OSApiRequest -HTTPVerb Put -Type network -Uri "/v2.0/ports/$ImputObject" -Property 'port' -ObjectType 'OS.Port' -Body $BodyObject)
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