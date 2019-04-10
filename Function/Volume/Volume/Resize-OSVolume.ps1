<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ID

    .PARAMETER Size

    The new size of the volume, in gibibytes (GiB).

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/block-storage/v3/#extend-a-volume-size

    .NOTES
#>
function Resize-OSVolume
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $ID,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$Size
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            foreach($ID in $ID)
            {
                $ID = Get-OSObjectIdentifierer -Object $ID -PropertyHint 'OS.Volume'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "resize Volume [$ID] to [$Size] GB"
                $Body = ([PSCustomObject]@{'os-extend'=[PSCustomObject]@{new_size=$Size}})
                Invoke-OSApiRequest -HTTPVerb Post -Type volumev3 -Uri "volumes/$ID/action" -NoOutput -Body $Body
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