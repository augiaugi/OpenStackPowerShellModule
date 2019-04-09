<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ImputObject

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#list-users-in-group

    .NOTES
#>
function Get-OSGroupMember
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Group')]
        $ImputObject
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            switch ($PsCmdlet.ParameterSetName)
            {
                'Default'
                {
                    foreach($ImputObject in $ImputObject)
                    {
                        #inteligent pipline
                        if($ImputObject.pstypenames[0] -eq 'OS.User')
                        {
                            Get-OSGroupMember -User $ImputObject
                        }
                        else 
                        {
                            $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Group'

                            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get GroupMembers [$ImputObject]"
                            Write-Output (Invoke-OSApiRequest -Type identity -Uri "groups/$ImputObject/users" -Property 'users' -ObjectType 'OS.User')
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