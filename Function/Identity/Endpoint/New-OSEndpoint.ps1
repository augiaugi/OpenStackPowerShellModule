<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Url

    The endpoint URL.
    
    .PARAMETER Interface

    The interface type, which describes the visibility of the endpoint. Value is: - public. Visible by end users on a publicly available network interface. - internal. Visible by end users on an unmetered internal network interface. - admin. Visible by administrative users on a secure network interface.

    .PARAMETER Service

    The UUID of the service to which the endpoint belongs.

    .PARAMETER Enabled

    Defines whether the endpoint appears in the service catalog: - false. The endpoint does not appear in the service catalog. - true. The endpoint appears in the service catalog. Default is true.

    .PARAMETER Region

    (Since v3.2) The ID of the region that contains the service endpoint.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#create-endpoints

    .NOTES
#>
function New-OSEndpoint
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Url,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateSet('admin', 'internal', 'public')]
        [ValidateNotNullOrEmpty()]
        [string]$Interface,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Service,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$Enabled,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $Region
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Endpoint [$Name]"
            
            $Properties = @{
                name=$Name
                interface=$Interface
                'service_id'=(Get-OSObjectIdentifierer -Object $Service -PropertyHint 'OS.Service')
            }
            if($Enabled){$Properties.Add('enabled', $Enabled)}
            if($Region){$Properties.Add('region_id', (Get-OSObjectIdentifierer -Object $Region -PropertyHint 'OS.Region'))}
            $Body = [PSCustomObject]@{endpoint=$Properties}

            Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type identity -Uri "endpoints" -Property 'endpoint' -ObjectType 'OS.CreateEndpoint' -Body $Body)
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