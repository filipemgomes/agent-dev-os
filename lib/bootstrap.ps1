function Write-JsonUtf8NoBom {
  param([object]$Value, [string]$Path, [int]$Depth = 20)
  [IO.File]::WriteAllText($Path, ($Value | ConvertTo-Json -Depth $Depth), (New-Object Text.UTF8Encoding($false)))
}

function Remove-ContextModeHooks {
  param([string]$Path)
  if (!(Test-Path -LiteralPath $Path)) { return }
  $bytes = [IO.File]::ReadAllBytes($Path)
  $offset = if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { 3 } else { 0 }
  $cfg = ([Text.Encoding]::UTF8.GetString($bytes, $offset, $bytes.Length - $offset)) | ConvertFrom-Json
  $changed = $false
  foreach ($event in @($cfg.hooks.PSObject.Properties)) {
    $groups = foreach ($group in @($event.Value)) {
      $kept = @($group.hooks | Where-Object { $_.command -notmatch '^context-mode hook codex ' })
      if ($kept.Count -ne @($group.hooks).Count) { $changed = $true }
      if ($kept.Count) { $group.hooks = $kept; $group }
    }
    $event.Value = @($groups)
  }
  if ($changed) { Write-JsonUtf8NoBom $cfg $Path }
}
