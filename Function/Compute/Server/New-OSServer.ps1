<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ID

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/#create-server

    .NOTES
#>
function New-OSServer
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Flavor
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            $Flavor = Get-OSObjectIdentifierer -Object $Flavor -PropertyHint 'OS.Flavor'

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Server [$Name], Flavor [$Flavor]"
                
            $Body = [PSCustomObject]@{server=[PSCustomObject]@{
                name=$Name
                flavorRef=$Flavor
            }}

            $Server = Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "servers" -Property 'server' -ObjectType 'OS.CreateServer' -Body $Body

            Get-OSServer -ID $Server.id
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