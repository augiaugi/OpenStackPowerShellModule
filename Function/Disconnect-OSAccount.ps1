<#
    .SYNOPSIS

    .DESCRIPTION

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

    https://developer.openstack.org/api-ref/identity/v3/#revoke-token

    .NOTES
#>
function Disconnect-OSAccount
{
    param
    (
    )

    try 
    {
        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message 'start'
 
        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "remove auth token"

        Invoke-OSApiRequest -HTTPVerb Delete -Type identity -Uri "/auth/tokens" -NoOutput

        $Global:OS_Username = $null
        $Global:OS_Domain = $null
        $Global:OS_Project = $null
        $Global:OS_AuthToken = $null
        $Global:OS_Endpoints = $null
        $Global:OS_EndpointInterfaceType = $null
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