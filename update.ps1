param([string]$InfrastructureRoot = (Join-Path $env:USERPROFILE '.dev-agent'), [string]$ProjectRoot = 'C:\dev')
& (Join-Path $PSScriptRoot 'install.ps1') -InfrastructureRoot $InfrastructureRoot -ProjectRoot $ProjectRoot
