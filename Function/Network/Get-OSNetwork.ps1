<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Port

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/?expanded=list-ports-detail#list-networks

    .NOTES
#>
function Get-OSNetwork
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'ImputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Network')]
        $ImputObject,

        [Parameter (ParameterSetName = 'Name', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Name
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Network"
                    Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/networks" -Property 'networks' -ObjectType 'OS.Network')
                }
                'ImputObject'
                {
                    foreach($ImputObject in $ImputObject)
                    {
                        $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Network'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Network [$ImputObject]"
                        Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/networks/$ImputObject" -Property 'network' -ObjectType 'OS.Network')
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Port [$Name]"
                        Write-Output (Get-OSNetwork | ?{$_.name -like $Name})
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