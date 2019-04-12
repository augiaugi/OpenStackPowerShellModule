<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ID

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    New-OSServer -Name Win2016 -Flavor (Get-OSFlavor -Name 'm1.small') -Image (Get-OSImage -Name 'Win2016')

    create a new server by Image

    .LINK

        https://developer.openstack.org/api-ref/compute/#create-server

    .NOTES
#>
function New-OSServer
{
    [CmdLetBinding(DefaultParameterSetName = 'Image')]
    Param
    (
        [Parameter (ParameterSetName = 'Image', Mandatory = $true)]
        [Parameter (ParameterSetName = 'Volume', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter (ParameterSetName = 'Image', Mandatory = $true)]
        [Parameter (ParameterSetName = 'Volume', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Flavor,

        [Parameter (ParameterSetName = 'Image', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Image,

        [Parameter (ParameterSetName = 'Volume', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Volume
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            $Flavor = Get-OSObjectIdentifierer -Object $Flavor -PropertyHint 'OS.Flavor'
            $BodyProperties = @{
                name=$Name
                flavorRef=$Flavor
            }

            switch ($PsCmdlet.ParameterSetName)
            {
                'Image'
                {
                    $Image = Get-OSObjectIdentifierer -Object $Image -PropertyHint 'OS.Image'

                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Server [$Name], Image [$Image], Flavor [$Flavor]"
                    
                    $BodyProperties.Add('imageRef', $Image)
                    $Body = [PSCustomObject]@{server=$BodyProperties}
                    Write-Output (Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "servers" -Property 'server' -ObjectType 'OS.CreateServer' -Body $Body)
                }
                'Volume'
                {
                    $Volume = Get-OSObjectIdentifierer -Object $Volume -PropertyHint 'OS.Volume'

                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Server [$Name], Volume [$Volume], Flavor [$Flavor]"

                    $VolumeProperties = [PSCustomObject]@{
                        boot_index=0
                        uuid=$Volume
                        source_type='volume'
                        destination_type='volume'
                    }

                    $BodyProperties.Add('block_device_mapping_v2', @($VolumeProperties))
                    $Body = [PSCustomObject]@{server=$BodyProperties}
                    Write-Output (Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "servers" -Property 'server' -ObjectType 'OS.CreateServer' -Body $Body)
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