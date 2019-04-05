<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Volume

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/#list-all-metadata

    .NOTES
#>
function Get-OSVolumeMetadata
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $Volume,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Key
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($Volume in $Volume)
            {
                $Volume = Get-OSObjectIdentifierer -Object $Volume -PropertyHint 'OS.Volume'

                if($Key)
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Volume [$Volume] metadata [$Key]"
                    Write-Output (Invoke-OSApiRequest -Type volumev3 -Uri "volumes/$Volume/metadata/$Key" -Property 'meta' -ObjectType 'OS.VolumeMetadata')
                }
                else 
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Volume [$Volume] metadata"
                    Write-Output (Invoke-OSApiRequest -Type volumev3 -Uri "volumes/$Volume/metadata" -Property 'metadata' -ObjectType 'OS.VolumeMetadata')       
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