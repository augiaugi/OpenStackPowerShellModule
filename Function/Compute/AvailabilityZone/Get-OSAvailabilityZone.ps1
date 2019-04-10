<#
    .SYNOPSIS

    .DESCRIPTION

    Lists and gets detailed availability zone information.

    An availability zone is created or updated by setting the availability_zone parameter in the create, update, or create or update methods of the Host Aggregates API. See Host Aggregates for more details.

    .PARAMETER ZoneName

    search by ZoneName

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/#list-aggregates

    .NOTES
#>
function Get-OSAvailabilityZone
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'ZoneName', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $ZoneName
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            switch ($PsCmdlet.ParameterSetName)
            {
                'Default'
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all AvailabilityZone"
                    Write-Output (Invoke-OSApiRequest -Type compute -Uri "/os-availability-zone/detail" -Property 'availabilityZoneInfo' -ObjectType 'OS.AvailabilityZone')
                }
                'ZoneName'
                {
                    foreach($ZoneName in $ZoneName)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get AvailabilityZone [$ZoneName]"
                        Write-Output (Get-OSAvailabilityZone | ?{$_.zoneName -like $ZoneName})
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