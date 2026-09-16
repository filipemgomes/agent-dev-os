param([string]$InfrastructureRoot = (Join-Path $env:USERPROFILE '.dev-agent'), [string]$ProjectRoot = 'C:\dev')
$ErrorActionPreference='SilentlyContinue'
function C([string]$n){[bool](Get-Command $n -ErrorAction SilentlyContinue)}
function Row([string]$n,[bool]$ok,[string]$why=''){if($ok){[Console]::WriteLine(('{0,-16} PASS' -f $n))}else{[Console]::WriteLine(('{0,-16} FAIL {1}' -f $n,$why))};return $ok}
Write-Output 'Agent Dev OS'; $ok=$true
$ok = (Row Git (C git 'install Git')) -and $ok
$ok = (Row OpenCode (C opencode 'install OpenCode')) -and $ok
$oc=Join-Path $env:USERPROFILE '.config\opencode\opencode.json'; $ocText=if(Test-Path $oc){Get-Content -Raw $oc}else{''}
$ok = (Row OMO ([bool]($ocText -match 'oh-my-openagent')) 'run install.ps1') -and $ok
$ok = (Row 'Context Mode' (C context-mode 'install context-mode')) -and $ok
$ok = (Row Context7 ([bool]($ocText -match 'context7') -or (Test-Path (Join-Path $env:USERPROFILE '.omo\omo.jsonc'))) 'enable through OMO/OpenCode') -and $ok
$ok = (Row RuleSync (C rulesync 'install RuleSync')) -and $ok
$ok = (Row Template (Test-Path (Join-Path $InfrastructureRoot 'template\.agent\current.json')) 'restore template') -and $ok
$path=[Environment]::GetEnvironmentVariable('Path','User'); $bin=Join-Path $InfrastructureRoot 'bin'
$ok = (Row PATH ((@($path -split ';')|Where-Object {$_ -eq $bin}).Count -eq 1) 'add .dev-agent\bin once') -and $ok
$activeConfigs=@($oc,(Join-Path $env:USERPROFILE '.omo\omo.jsonc')) | Where-Object {Test-Path -LiteralPath $_}
$bad=$activeConfigs | Select-String -Pattern 'approval_policy\s*=\s*["'']?never|danger-full-access|auto-push|auto-delete' -ErrorAction SilentlyContinue
$ok = (Row Security (-not $bad) 'remove dangerous global settings') -and $ok
Write-Output ''; if($ok){'Overall: READY';exit 0}else{'Overall: FAIL';exit 1}
