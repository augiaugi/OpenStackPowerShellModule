<#
    .SYNOPSIS

    .DESCRIPTION

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/#show-rate-and-absolute-limits

    .NOTES
#>
function Get-OSLimit
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

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Limit"
            Write-Output (Invoke-OSApiRequest -Type compute -Uri "/limits" -Property 'limits.absolute' -ObjectType 'OS.Limit')
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