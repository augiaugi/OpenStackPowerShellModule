﻿<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER ImputObject

    .PARAMETER Name

    .PARAMETER Description

    .PARAMETER AllowedAddressPair

    A set of zero or more allowed address pair objects each where address pair object contains an ip_address and mac_address. While the ip_address is required, the mac_address will be taken from the port if not specified. The value of ip_address can be an IP Address or a CIDR (if supported by the underlying extension plugin). A server connected to the port can send a packet with source address which matches one of the specified allowed address pairs.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/#update-port

    .NOTES
#>
function Set-OSPort
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Port')]
        $ImputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [string]$Description,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [string[]]$AllowedAddressPair
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($ImputObject in $ImputObject)
            {
                $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Port'

                $BodyProperties = @{}
                if($PSBoundParameters.ContainsKey('Name')){$BodyProperties.Add('name', $Name)}
                if($PSBoundParameters.ContainsKey('Description')){$BodyProperties.Add('description', $Description)}
                if($PSBoundParameters.ContainsKey('AllowedAddressPair')){$BodyProperties.Add('allowed_address_pairs', @($AllowedAddressPair))}
                $BodyObject = [PSCustomObject]@{port=$BodyProperties}

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "set Port [$ImputObject]"
                
                Write-Output (Invoke-OSApiRequest -HTTPVerb Put -Type network -Uri "/v2.0/ports/$ImputObject" -Property 'port' -ObjectType 'OS.Port' -Body $BodyObject)
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