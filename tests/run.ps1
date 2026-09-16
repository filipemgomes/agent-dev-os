$ErrorActionPreference='Stop'; $root=Split-Path $PSScriptRoot -Parent
. (Join-Path $root 'lib\bootstrap.ps1')
function Assert([bool]$v,[string]$m){if(!$v){throw $m}}
Assert (Test-Path (Join-Path $root 'template\.agent\current.json')) 'missing task state'
Assert (Test-Path (Join-Path $root 'template\.rulesync')) 'missing rulesync source'
$personalPattern=('Filipe'+' Gomes|C:'+'\\Projects')
$files=Get-ChildItem $root -Recurse -Force -File | Where-Object {$_.FullName -notlike '*\.git\*' -and $_.Name -ne 'run.ps1'}
$personal=foreach($f in $files){if((Get-Content -Raw $f.FullName) -match $personalPattern){$f}}
Assert (-not $personal) 'personal path found'
$templateFiles=Get-ChildItem (Join-Path $root 'template') -Recurse -Force -File
$secrets=foreach($f in $templateFiles){if((Get-Content -Raw $f.FullName) -match 'credentials|api.?key|oauth|token'){ $f }}
Assert (-not $secrets) 'secret-like template content found'
Assert ((Get-Content -Raw (Join-Path $root 'template\.agent\current.json')|ConvertFrom-Json).status -eq 'idle') 'invalid initial state'
$probe=Join-Path ([IO.Path]::GetTempPath()) ('agent-dev-hooks-' + [guid]::NewGuid() + '.json')
try {
  $sample=[ordered]@{hooks=[ordered]@{
    PreToolUse=@([ordered]@{matcher='*';hooks=@([ordered]@{type='command';command='context-mode hook codex pretooluse'},[ordered]@{type='command';command='keep-this-hook'})})
    PostToolUse=@([ordered]@{hooks=@([ordered]@{type='command';command='context-mode hook codex posttooluse'})})
  }}
  [IO.File]::WriteAllText($probe, ($sample|ConvertTo-Json -Depth 10), (New-Object Text.UTF8Encoding($true)))
  Remove-ContextModeHooks $probe
  $bytes=[IO.File]::ReadAllBytes($probe); Assert (-not ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)) 'BOM remained'
  $result=Get-Content -Raw $probe|ConvertFrom-Json
  Assert (@($result.hooks.PreToolUse[0].hooks).Count -eq 1) 'Context Mode duplicate not removed'
  Assert ($result.hooks.PreToolUse[0].hooks[0].command -eq 'keep-this-hook') 'legitimate hook was removed'
  Assert (@($result.hooks.PostToolUse).Count -eq 0) 'empty duplicate group remained'
} finally { Remove-Item -LiteralPath $probe -Force -ErrorAction SilentlyContinue }
Write-Output 'PASS template, paths, secret scan, task state, hook BOM and duplicate cleanup'
