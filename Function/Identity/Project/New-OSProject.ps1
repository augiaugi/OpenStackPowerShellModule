<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Name

    The name of the project.    

    .PARAMETER Enabled

    If set to true, project is enabled. If set to false, project is disabled. The default is true.

    .PARAMETER Description

    The description of the project.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#create-project

    .NOTES
#>
function New-OSProject
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

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create Project [$Name]"
            
            $Properties = @{
                name=$Name
            }
            if($Enabled){$Properties.Add('enabled ', $Enabled)}
            if($Description){$Properties.Add('description', $Description)}
            $Body = [PSCustomObject]@{project=$Properties}

            Write-Output(Invoke-OSApiRequest -HTTPVerb Post -Type identity -Uri "projects" -Property 'project' -ObjectType 'OS.CreateProject' -Body $Body)
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