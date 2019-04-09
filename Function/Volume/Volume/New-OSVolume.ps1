<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Size

    The size of the volume, in gibibytes (GiB).

    .PARAMETER Name

    The volume name.

    .PARAMETER Description

    The volume description.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    New-OSVolume -Size 1 -Name 'OS_disk'

    .LINK

        https://developer.openstack.org/api-ref/block-storage/v3/#create-a-volume

    .NOTES
#>
function New-OSVolume
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$Size,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Volume [$Size], Name [$Name]"
                 
            $Properties = @{
                size=$Size
            }
            if($Name){$Properties.Add('name', $Name)}
            if($Description){$Properties.Add('description', $Description)}
            $Body = [PSCustomObject]@{volume=$Properties}

            Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type volumev3 -Uri "volumes" -Property 'volume' -ObjectType 'OS.CreateVolume' -Body $Body)
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