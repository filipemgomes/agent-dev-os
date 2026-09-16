param([Parameter(Position=0)][ValidateSet('doctor','update','new','export','import','info')][string]$Command='info',[Parameter(ValueFromRemainingArguments=$true)][string[]]$Args)
$ErrorActionPreference='Stop'; $root=Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
switch($Command){
  'doctor'{& (Join-Path $root 'doctor.ps1') @Args}
  'update'{& (Join-Path $root 'update.ps1') @Args}
  'new'{& (Join-Path $root 'bin\newdev.ps1') @Args}
  'export'{& (Join-Path $root 'export-profile.ps1') @Args}
  'import'{& (Join-Path $root 'import-profile.ps1') @Args}
  'info'{Write-Output 'Agent Dev OS';Write-Output "InfrastructureRoot=$(Join-Path $env:USERPROFILE '.dev-agent')";Write-Output 'Use: agentdev doctor|update|new|export|import'}
}
