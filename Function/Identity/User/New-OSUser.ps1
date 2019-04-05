<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Name

    The name of the user.    
    
    .PARAMETER Password

    The password for the user.

    .PARAMETER Enabled

    If the user is enabled, this value is true. If the user is disabled, this value is false.

    .PARAMETER DefaultProject

    The ID of the default project for the user. A user’s default project must not be a domain. Setting this attribute does not grant any actual authorization on the project, and is merely provided for convenience. Therefore, the referenced project does not need to exist within the user domain. (Since v3.1) If the user does not have authorization to their default project, the default project is ignored at token creation. (Since v3.1) Additionally, if your default project is not valid, a token is issued without an explicit scope of authorization.

    .PARAMETER Domain

    The ID of the domain of the user. If the domain ID is not provided in the request, the Identity service will attempt to pull the domain ID from the token used in the request. Note that this requires the use of a domain-scoped token.

    .PARAMETER Description

    The description of the user.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/?delete-group&expanded=create-user-detail#create-user

    .NOTES
#>
function New-OSUser
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [SecureString]$Password,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$Enabled,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $DefaultProject,

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

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create User [$Name]"

            $Properties = @{
                name=$Name
            }
            if($Password){$Properties.Add('password', (ConvertFrom-SecureString $Password))}
            if($Enabled){$Properties.Add('enabled ', $Enabled)}
            if($DefaultProject){$Properties.Add('default_project_id ', (Get-OSObjectIdentifierer -Object $DefaultProject -PropertyHint 'OS.Project'))}
            if($Domain){$Properties.Add('domain_id', (Get-OSObjectIdentifierer -Object $Domain -PropertyHint 'OS.Domain'))}
            if($Description){$Properties.Add('description', $Description)}
            $Body = [PSCustomObject]@{user=$Properties}

            Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type identity -Uri "users" -Property 'user' -ObjectType 'OS.CreateUser' -Body $Body)
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