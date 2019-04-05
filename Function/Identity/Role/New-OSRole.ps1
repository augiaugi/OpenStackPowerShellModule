<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Name

    The name of the role.    

    .PARAMETER Enabled

    The ID of the domain of the role.

    .PARAMETER Description

    The description of the role.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#create-role

    .NOTES
#>
function New-OSRole
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

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Role [$Name]"
            
            $Properties = @{
                name=$Name
            }
            if($Domain){$Properties.Add('domain_id', (Get-OSObjectIdentifierer -Object $Domain -PropertyHint 'OS.Domain'))}
            if($Description){$Properties.Add('description', $Description)}
            $Body = [PSCustomObject]@{role=$Properties}

            Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type identity -Uri "roles" -Property 'role' -ObjectType 'OS.CreateRole' -Body $Body)
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