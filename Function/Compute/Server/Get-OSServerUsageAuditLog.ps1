<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Timestamp

    Filters the response by the date and time before which to list usage audits. The date and time stamp format is as follows:

    CCYY-MM-DD hh:mm:ss.NNNNNN

    For example, 2015-08-27 09:49:58 or 2015-08-27 09:49:58.123456.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/#list-server-usage-audits

    .NOTES
#>
function Get-OSServerUsageAuditLog
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [DateTime]$Timestamp
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            if($Timestamp)
            {
                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get ServerUsageAuditLog, Timestamp [$Timestamp]"
                Write-Output (Invoke-OSApiRequest -Type compute -Uri "/os-instance_usage_audit_log/$($Timestamp.ToString('yyyy-MM-dd hh:mm:ss'))" -Property 'instance_usage_audit_log' -ObjectType 'OS.ServerUsageAuditLog')
            }
            else 
            {
                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get ServerUsageAuditLog"
                Write-Output (Invoke-OSApiRequest -Type compute -Uri "/os-instance_usage_audit_log" -Property 'instance_usage_audit_logs' -ObjectType 'OS.ServerUsageAuditLog')
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