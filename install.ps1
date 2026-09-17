param(
  [string]$InfrastructureRoot = (Join-Path $env:USERPROFILE '.dev-agent'),
  [string]$ProjectRoot = 'C:\dev',
  [switch]$NoSmoke
)
$ErrorActionPreference = 'Stop'
$RepoRoot = $PSScriptRoot
. (Join-Path $RepoRoot 'lib\bootstrap.ps1')
$BackupRoot = Join-Path $InfrastructureRoot 'backups'
$StateRoot = Join-Path $InfrastructureRoot 'state'
New-Item -ItemType Directory -Force -Path $InfrastructureRoot,$BackupRoot,$StateRoot,(Join-Path $InfrastructureRoot 'bin') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $InfrastructureRoot 'lib') | Out-Null

function Has-Command([string]$Name) { return [bool](Get-Command $Name -ErrorAction SilentlyContinue) }
function Backup-IfPresent([string]$Path) {
  if (Test-Path -LiteralPath $Path) {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $dest = Join-Path $BackupRoot $stamp
    New-Item -ItemType Directory -Force $dest | Out-Null
    Copy-Item -LiteralPath $Path -Destination $dest -Recurse -Force
  }
}
function Add-UserPath([string]$Path) {
  $old = [Environment]::GetEnvironmentVariable('Path','User')
  $parts = @($old -split ';' | Where-Object { $_ -and $_ -ne $Path })
  [Environment]::SetEnvironmentVariable('Path', (($parts + $Path) -join ';'), 'User')
}
function Assert-ExternalInstall([string]$Name) {
  if ($LASTEXITCODE -ne 0) { throw "$Name installation failed with exit code $LASTEXITCODE." }
}

if (!(Has-Command git)) { throw 'Git is required. Install Git for Windows, then rerun install.ps1.' }
if (!(Has-Command node) -or !(Has-Command npm)) { throw 'Node.js/npm is required. Install Node.js LTS, then rerun install.ps1.' }
if (!(Has-Command bun)) { npm install -g bun }
if (!(Has-Command opencode)) { npm install -g opencode-ai }
if (!(Has-Command rulesync)) { npm install -g rulesync }
if (!(Has-Command context-mode)) { npm install -g context-mode }

$sourceTemplate = Join-Path $RepoRoot 'template'
$installedTemplate = Join-Path $InfrastructureRoot 'template'
if (Test-Path -LiteralPath $installedTemplate) {
  Backup-IfPresent $installedTemplate
  Remove-Item -LiteralPath $installedTemplate -Recurse -Force
}
Copy-Item -LiteralPath $sourceTemplate -Destination $installedTemplate -Recurse -Force

$oc = Join-Path $env:USERPROFILE '.config\opencode\opencode.json'
Backup-IfPresent $oc
$ocText = if (Test-Path -LiteralPath $oc) { Get-Content -Raw $oc } else { '' }
$hasOmo = (Test-Path -LiteralPath (Join-Path $env:USERPROFILE '.omo\omo.jsonc')) -and ($ocText -match 'oh-my-openagent')
if (!$hasOmo) {
  bunx oh-my-openagent install --no-tui --platform=opencode --claude=no --openai=no --gemini=no --copilot=no --opencode-zen=no --skip-auth
}
if (Test-Path -LiteralPath $oc) {
  $cfg = Get-Content -Raw $oc | ConvertFrom-Json
  $plugins = @($cfg.plugin)
  if (!($plugins -contains 'context-mode')) { $cfg.plugin = @($plugins + 'context-mode') }
  Write-JsonUtf8NoBom $cfg $oc
}
Remove-ContextModeHooks (Join-Path $env:USERPROFILE '.codex\hooks.json')

Copy-Item -LiteralPath (Join-Path $RepoRoot 'bin\newdev.ps1') -Destination (Join-Path $InfrastructureRoot 'bin\newdev.ps1') -Force
Copy-Item -LiteralPath (Join-Path $RepoRoot 'bin\newdev.cmd') -Destination (Join-Path $InfrastructureRoot 'bin\newdev.cmd') -Force
Copy-Item -LiteralPath (Join-Path $RepoRoot 'bin\agentdev.ps1') -Destination (Join-Path $InfrastructureRoot 'bin\agentdev.ps1') -Force
foreach($name in 'doctor.ps1','update.ps1','export-profile.ps1','import-profile.ps1','uninstall.ps1') { Copy-Item -LiteralPath (Join-Path $RepoRoot $name) -Destination (Join-Path $InfrastructureRoot $name) -Force }
Copy-Item -LiteralPath (Join-Path $RepoRoot 'lib\bootstrap.ps1') -Destination (Join-Path $InfrastructureRoot 'lib\bootstrap.ps1') -Force

Push-Location $installedTemplate
try {
  rulesync generate --targets opencode,claudecode,codexcli --features rules,skills,mcp,subagents,hooks,permissions,checks | Out-Null

  Write-Output 'Installing UI/Product design skills...'
  npx --yes impeccable install -y --providers=claude,codex,opencode --scope=project --no-hooks
  Assert-ExternalInstall 'Impeccable'

  npx --yes skills add vercel-labs/agent-skills --skill web-design-guidelines --agent claude-code codex opencode --yes --copy
  Assert-ExternalInstall 'Vercel web-design-guidelines'

  npx --yes skills add 21st-dev/skill --skill 21st-cli-use --skill 21st-ui-build --skill 21st-ui-explore --skill 21st-ui-review --agent claude-code codex opencode --yes --copy
  Assert-ExternalInstall '21st.dev UI skills'
}
finally { Pop-Location }

Add-UserPath (Join-Path $InfrastructureRoot 'bin')
[Environment]::SetEnvironmentVariable('AGENT_DEV_OS_ROOT',$InfrastructureRoot,'User')

$manifest = [ordered]@{ version=1; infrastructureRoot=$InfrastructureRoot; projectRoot=$ProjectRoot; controlled=@('bin\newdev.ps1','bin\newdev.cmd','bin\agentdev.ps1','doctor.ps1','update.ps1','export-profile.ps1','import-profile.ps1','uninstall.ps1','lib\bootstrap.ps1','template'); installedAt=(Get-Date).ToUniversalTime().ToString('o') }
Write-JsonUtf8NoBom $manifest (Join-Path $StateRoot 'manifest.json') 5
if (!$NoSmoke) { & (Join-Path $RepoRoot 'doctor.ps1') -InfrastructureRoot $InfrastructureRoot -ProjectRoot $ProjectRoot }
Write-Output 'READY'
