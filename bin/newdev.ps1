param([Parameter(Mandatory=$true,Position=0)][string]$Name,[Parameter(Position=1)][string]$Parent='C:\dev',[switch]$NoOpen,[string]$InfrastructureRoot=$(if($env:AGENT_DEV_OS_ROOT){$env:AGENT_DEV_OS_ROOT}else{Join-Path $env:USERPROFILE '.dev-agent'}))
$ErrorActionPreference='Stop'; $template=Join-Path $InfrastructureRoot 'template'
. (Join-Path $PSScriptRoot '..\lib\bootstrap.ps1')
if(!(Test-Path -LiteralPath $template)){throw "Template not found: $template"}
$parentPath=[IO.Path]::GetFullPath($Parent); New-Item -ItemType Directory -Force $parentPath|Out-Null
$target=Join-Path $parentPath $Name; if(Test-Path -LiteralPath $target){throw "Target already exists: $target"}
New-Item -ItemType Directory -Force $target|Out-Null
Get-ChildItem -LiteralPath $template -Force|Copy-Item -Destination $target -Recurse -Force
Set-Location -LiteralPath $target; New-Item -ItemType Directory -Force (Join-Path $target '.agent\tasks')|Out-Null; git init|Out-Null
rulesync generate --targets opencode,claudecode,codexcli --features rules,skills,mcp,subagents,hooks,permissions,checks|Out-Null
$state=[ordered]@{task=$null;status='idle';next=$null;blocker=$null;verification=$null;lastCheckpoint=$null}; Write-JsonUtf8NoBom $state (Join-Path $target '.agent\current.json')
rulesync generate --targets opencode,claudecode,codexcli --features rules,skills,mcp,subagents,hooks,permissions,checks --check|Out-Null
Write-Output "Created $target"; if(!$NoOpen){opencode}
