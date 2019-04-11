<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ImputObject

    The source volume ID.

    .PARAMETER Name

    The backup name.
   
    .PARAMETER Description

    The backup description.

    .PARAMETER Force

    Indicates whether to create a backup, even if the volume is attached.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/block-storage/v3/#create-a-backup

    .NOTES
#>
function New-OSVolumeBackup
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Volume')]
        $ImputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [switch]$Force
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($ImputObject in $ImputObject)
            {
                $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Volume'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create VolumeBackup [$Name] from Volume [$ImputObject]"
                    
                $Body = [PSCustomObject]@{backup=$null}
                $BodyProperties = @{
                    'volume_id' = $ImputObject
                }
                if($Name){$BodyProperties.Add('name', $Name)}
                if($Description){$BodyProperties.Add('description', $Description)}
                if($Force){$BodyProperties.Add('force', $true)}
                $Body.backup = $BodyProperties

                Write-Output (Invoke-OSApiRequest -HTTPVerb Post -Type volumev3 -Uri "backups" -Property 'backup' -ObjectType 'OS.CreateVolumeBackup' -Body $Body)
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