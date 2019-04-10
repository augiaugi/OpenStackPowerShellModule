<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Image

    .PARAMETER Name

    search flavor by name

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=#list-flavors

    .NOTES
#>
function Get-OSFlavor
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'ImputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Flavor')]
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Flavors"
                    Write-Output (Invoke-OSApiRequest -Type compute -Uri "/flavors/detail" -Property 'flavors' -ObjectType 'OS.Flavor')
                }
                'ImputObject'
                {
                    foreach($ImputObject in $ImputObject)
                    {
                        #inteligent pipline
                        if($ImputObject.pstypenames[0] -eq 'OS.Server')
                        {
                            Get-OSFlavor -ID $ImputObject.flavor.id
                        }
                        else 
                        {
                            $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Flavor'

                            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Flavor [$ImputObject]"
                            Write-Output (Invoke-OSApiRequest -Type compute -Uri "/flavors/$ImputObject" -Property 'flavor' -ObjectType 'OS.Flavor')
                        }
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Flavor [$Name]"
                        Write-Output (Get-OSFlavor | ?{$_.name -like $Name})
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