<#
    .SYNOPSIS

    .DESCRIPTION

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=#show-hypervisor-statistics

    .NOTES
#>
function Get-OSHypervisorStatistic
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Hypervisor statistic"
            Write-Output (Invoke-OSApiRequest -Type compute -Uri "/os-hypervisors/statistics" -Property 'hypervisor_statistics' -ObjectType 'OS.HypervisorStatistic')
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