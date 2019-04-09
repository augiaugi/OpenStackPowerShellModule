<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Name

    The service name.
    
    .PARAMETER Type

    The service type, which describes the API implemented by the service. Value is compute, ec2, identity, image, network, or volume.

    .PARAMETER Enabled

    Defines whether the service and its endpoints appear in the service catalog: - false. The service and its endpoints do not appear in the service catalog. - true. The service and its endpoints appear in the service catalog.

    .PARAMETER Description

    The service description.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#create-services

    .NOTES
#>
function New-OSDomain
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateSet('compute', 'ec2', 'identity', 'image', 'network', 'volume')]
        [ValidateNotNullOrEmpty()]
        [string]$Type,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$Enabled,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Service [$Name]"
            
            $Properties = @{
                name=$Name
                type=$Type
            }
            if($Enabled){$Properties.Add('enabled', $Enabled)}
            if($Description){$Properties.Add('description', $Description)}
            $Body = [PSCustomObject]@{service=$Properties}

            Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type identity -Uri "services" -Property 'service' -ObjectType 'OS.CreateService' -Body $Body)
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