<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Name

    The display name of a flavor.

    .PARAMETER RAM

    A free form description of the flavor. Limited to 65535 characters in length. Only printable characters are allowed.

    .PARAMETER Disk

    The size of the root disk that will be created in GiB. If 0 the root disk will be set to exactly the size of the image used to deploy the instance. However, in this case filter scheduler cannot select the compute host based on the virtual image size. Therefore, 0 should only be used for volume booted instances or for testing purposes. Volume-backed instances can be enforced for flavors with zero root disk via the os_compute_api:servers:create:zero_disk_flavor policy rule.

    .PARAMETER CPU

    The number of virtual CPUs that will be allocated to the server.

    .PARAMETER Description

    A free form description of the flavor. Limited to 65535 characters in length. Only printable characters are allowed.

    New in version 2.55

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=#create-flavor

    .NOTES
#>
function New-OSFlavor
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$RAM,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$Disk,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$CPU,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Flavor [$Name], RAM [$RAM], Disk [$Disk], CPU [$CPU]"
                
            $Body = [PSCustomObject]@{flavor=$null}
            $BodyProperties = @{
                name=$Name
                ram=$RAM
                disk=$Disk
                vcpus=$CPU
            }
            if($Description){$BodyProperties.Add('description', $Description)}
            $Body.flavor = $BodyProperties

            $Flavor = Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "flavors" -Property 'flavor' -ObjectType 'OS.CreateFlavor' -Body $Body

            Get-OSFlavor -ID $Flavor.id
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