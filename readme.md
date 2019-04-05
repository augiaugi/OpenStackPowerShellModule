# OpenStack PowerShell module

This is a PowerShell module to manage OpenStack directly via OpenStack API.

For more information about the examples, roadmap, changelog, known issues, development guides, ... see the [wiki](https://github.com/augiaugi/OpenStackPowerShellModule/wiki). 

## Installation

Download the zip file and extract it one of your desired PowerShell module paths  ([Installing a PowerShell Module](https://docs.microsoft.com/en-us/powershell/developer/module/installing-a-powershell-module)).

    $Env:PSModulePath -split ';'

## Import the Module

    Import-Module OpenStack
    Get-Command -Module OpenStack

## Authenticate

    Connect-OSAccount -Credential (Get-Credential) -Project '<Project>' -AuthenticationUri 'http://<IP>:<Port>/v3/auth/tokens'

## Examples

get all server

    Get-OSServer
    
get server by ID

    Get-OSServer -ID ce847820-4d6b-47f0-b0e5-486457fe1044

search server by name (wildcard possible)

    Get-OSServer -Name "<Name>"

You can find more examples [here](https://github.com/augiaugi/OpenStackPowerShellModule/wiki/Examples).