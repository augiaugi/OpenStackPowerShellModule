<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ImputObject

    .PARAMETER Name

    .PARAMETER Server

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/block-storage/v3/?expanded=#list-accessible-volumes-with-details

    .NOTES
#>
function Get-OSVolume
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'ImputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Volume')]
        $ImputObject,

        [Parameter (ParameterSetName = 'Name', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Name,

        [Parameter (ParameterSetName = 'Server', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Server
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Volume"
                    Write-Output (Invoke-OSApiRequest -Type volumev3 -Uri "volumes/detail" -Property 'volumes' -ObjectType 'OS.Volume')
                }
                'ImputObject'
                {
                    foreach($ImputObject in $ImputObject)
                    {
                        $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Volume'

                        #if multiple objects gets returned
                        foreach($ImputObject in $ImputObject)
                        {
                            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Volume [$ImputObject]"
                            Write-Output (Invoke-OSApiRequest -Type volumev3 -Uri "volumes/$ImputObject" -Property 'volume' -ObjectType 'OS.Volume')
                        }
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Volume [$Name]"
                        Write-Output (Get-OSVolume | ?{$_.name -like $Name})
                    }
                }
                'Server'
                {
                    foreach($Server in $Server)
                    {
                        $Server = Get-OSServer -ID $Server
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Volumes from Server [$($Server.id)]"

                        if($Server.'os-extended-volumes:volumes_attached'.id)
                        {
                            Write-Output (Get-OSVolume -ID $Server.'os-extended-volumes:volumes_attached'.id)
                        }
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