<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ID

    The ID for the region.   

    .PARAMETER Description

    The region description.

    .PARAMETER ParentRegion

    To make this region a child of another region, set this parameter to the ID of the parent region.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#create-regions

    .NOTES
#>
function New-OSRegion
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ID,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,
        
        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $ParentRegion
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Region [$ID]"
            
            $Properties = @{
            }
            if($ID){$Properties.Add('id', $ID)}
            if($Description){$Properties.Add('description', $Description)}
            if($ParentRegion){$Properties.Add('parent_region_id', (Get-OSObjectIdentifierer -Object $ParentRegion -PropertyHint 'OS.Region'))}
            $Body = [PSCustomObject]@{region=$Properties}

            Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type identity -Uri "regions" -Property 'region' -ObjectType 'OS.CreateRegion' -Body $Body)
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