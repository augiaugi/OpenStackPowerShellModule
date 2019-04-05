$ErrorActionPreference = 'Stop'

Get-ChildItem -Path "$PSScriptRoot\Core" -File -Recurse | ?{$_.Extension -eq '.ps1'} | %{. $_.FullName}
Get-ChildItem -Path "$PSScriptRoot\Function" -File -Recurse | ?{$_.Extension -eq '.ps1'} | %{. $_.FullName}