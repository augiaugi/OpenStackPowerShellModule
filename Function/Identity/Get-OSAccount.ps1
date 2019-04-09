<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .EXAMPLE

    .LINK

    .NOTES
#>
function Get-OSAccount
{
    param
    (
    )

    try 
    {
        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message 'start'

        Write-Output(
            [PSCustomObject]@{
                Username = $Global:OS_Username
                Domain = $Global:OS_Domain
                Project = $Global:OS_Project
                Endpoints = $Global:OS_Endpoints
                EndpointInterfaceType = $Global:OS_EndpointInterfaceType
            }   
        )
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