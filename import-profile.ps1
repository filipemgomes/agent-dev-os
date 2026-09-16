param([Parameter(Mandatory=$true)][string]$Profile, [string]$InfrastructureRoot = (Join-Path $env:USERPROFILE '.dev-agent'))
. (Join-Path $PSScriptRoot 'lib\bootstrap.ps1')
$p=Get-Content -Raw $Profile|ConvertFrom-Json; New-Item -ItemType Directory -Force (Join-Path $InfrastructureRoot 'state')|Out-Null; Write-JsonUtf8NoBom $p (Join-Path $InfrastructureRoot 'state\profile.json'); Write-Output 'Profile imported without credentials.'
