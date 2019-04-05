<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=#stop-server-os-stop-action

    .NOTES
#>
function Stop-OSServer
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $ID
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($ID in $ID)
            {
                $ID = Get-OSObjectIdentifierer -Object $ID -PropertyHint 'OS.Server'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "stop Server [$ID]"
                
                Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "servers/$ID" -NoOutput -Body ([PSCustomObject]@{'os-stop'=$null})
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