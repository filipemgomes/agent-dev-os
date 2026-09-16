param([string]$Output = 'agent-dev-profile.json', [string]$ProjectRoot = 'C:\dev')
. (Join-Path $PSScriptRoot 'lib\bootstrap.ps1')
$profile=[ordered]@{projectRoot=$ProjectRoot;enabledProviders=@('anthropic','openai');contextMode=$true;context7=$true;orchestrator='oh-my-openagent';version=1}
Write-JsonUtf8NoBom $profile $Output; Write-Output (Resolve-Path $Output)
