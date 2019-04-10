<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ImputObject

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

    https://developer.openstack.org/api-ref/compute/#show-server-diagnostics

    .NOTES
#>
function Get-OSServerDiagnostic
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Server')]
        $ImputObject
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Server'

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Server [$ImputObject] Diagnostic"
            Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/$ImputObject/diagnostics" -ObjectType 'OS.ServerDiagnostic')
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