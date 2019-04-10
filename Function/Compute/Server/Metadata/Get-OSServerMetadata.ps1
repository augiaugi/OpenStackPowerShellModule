<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/#list-all-metadata

    .NOTES
#>
function Get-OSServerMetadata
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $Server,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Key
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($Server in $Server)
            {
                $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'

                if($Key)
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Server [$Server] metadata [$Key]"
                    Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/$Server/metadata/$Key" -Property 'meta' -ObjectType 'OS.ServerMetadata')
                }
                else 
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Server [$Server] metadata"
                    Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/$Server/metadata" -Property 'metadata' -ObjectType 'OS.ServerMetadata')       
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