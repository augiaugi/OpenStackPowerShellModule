<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Name

    The name of the domain.    

    .PARAMETER Enabled

    If set to true, domain is created enabled. If set to false, domain is created disabled. The default is true.

    Users can only authorize against an enabled domain (and any of its projects). In addition, users can only authenticate if the domain that owns them is also enabled. Disabling a domain prevents both of these things.

    .PARAMETER Description

    The description of the domain.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#create-domain

    .NOTES
#>
function New-OSDomain
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$Enabled,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Domain [$Name]"
            
            $Properties = @{
                name=$Name
            }
            if($Enabled){$Properties.Add('enabled', $Enabled)}
            if($Description){$Properties.Add('description', $Description)}
            $Body = [PSCustomObject]@{domain=$Properties}

            Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type identity -Uri "domains" -Property 'domain' -ObjectType 'OS.CreateDomain' -Body $Body)
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