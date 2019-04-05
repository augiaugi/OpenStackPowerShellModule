<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Name

    The name of the group.

    .PARAMETER Domain

    The ID of the domain of the group. If the domain ID is not provided in the request, the Identity service will attempt to pull the domain ID from the token used in the request. Note that this requires the use of a domain-scoped token.

    .PARAMETER Description

    The description of the group.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/?delete-group&expanded=#create-user

    .NOTES
#>
function New-OSGroup
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $Domain,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Group [$Name]"
                 
            $Properties = @{
                name=$Name
            }
            if($Domain){$Properties.Add('domain_id', (Get-OSObjectIdentifierer -Object $Domain -PropertyHint 'OS.Domain'))}
            if($Description){$Properties.Add('description', $Description)}
            $Body = [PSCustomObject]@{group=$Properties}

            Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type identity -Uri "groups" -Property 'group' -ObjectType 'OS.CreateGroup' -Body $Body)
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