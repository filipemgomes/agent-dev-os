param([string]$InfrastructureRoot = (Join-Path $env:USERPROFILE '.dev-agent'))
$ErrorActionPreference='Stop'; $bin=Join-Path $InfrastructureRoot 'bin'; $path=[Environment]::GetEnvironmentVariable('Path','User')
[Environment]::SetEnvironmentVariable('Path', (($path -split ';'|Where-Object {$_ -and $_ -ne $bin}) -join ';'), 'User')
$manifest=Join-Path $InfrastructureRoot 'state\manifest.json'
if(Test-Path $manifest){$m=Get-Content -Raw $manifest|ConvertFrom-Json; foreach($item in $m.controlled){$p=Join-Path $InfrastructureRoot $item;if(Test-Path $p){Remove-Item -LiteralPath $p -Recurse -Force}}}
Write-Output 'Agent Dev OS files and PATH entry removed. Existing agent tools were not uninstalled.'
