<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ImputObject

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=#show-hypervisor-uptime

    .NOTES
#>
function Get-OSHypervisorUptime
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Hypervisor')]
        $ImputObject
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            foreach($ImputObject in $ImputObject)
            {
                $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Hypervisor'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Hypervisor [$ImputObject] uptime"
                Write-Output (Invoke-OSApiRequest -Type compute -Uri "/os-hypervisors/$ImputObject/uptime" -Property 'hypervisor' -ObjectType 'OS.HypervisorUptime')
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