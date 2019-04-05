<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ImputObject

    .PARAMETER User

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#add-user-to-group

    .NOTES
#>
function Add-OSGroupMember
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Group')]
        $ImputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $User
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Group'

            foreach($User in $User)
            {
                $User = Get-OSObjectIdentifierer -Object $User -PropertyHint 'OS.User'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "add User [$User] to Group [$ImputObject]"

                Invoke-OSApiRequest -HTTPVerb Put -Type identity -Uri "groups/$ImputObject/users/$User" -Body $Body -NoOutput
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