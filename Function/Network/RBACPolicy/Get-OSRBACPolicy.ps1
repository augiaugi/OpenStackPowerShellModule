<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ImputObject

    .PARAMETER Name

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/?expanded=#list-rbac-policies

    .NOTES
#>
function Get-OSRBACPolicy
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'ImputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'RBACPolicy')]
        $ImputObject
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            switch ($PsCmdlet.ParameterSetName)
            {
                'All'
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all RBACPolicy"
                    Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/rbac_policies" -Property 'rbac_policies' -ObjectType 'OS.RBACPolicy')
                }
                'ImputObject'
                {
                    foreach($ImputObject in $ImputObject)
                    {
                        $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.RBACPolicy'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get RBACPolicy [$ImputObject]"
                        Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/rbac_policies/$ImputObject" -Property 'rbac_policie' -ObjectType 'OS.RBACPolicy')
                    }
                }
                default
                {
                    throw "unexpected ParameterSetName [$ParameterSetName]"
                }
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