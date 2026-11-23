$ErrorActionPreference = 'Stop'
$appDir = $PSScriptRoot
$root   = Split-Path -Parent $appDir
$name   = 'Onoseto'
$html   = Join-Path $appDir 'onoseto.html'
$ico    = Join-Path $appDir 'ikona.ico'
$url    = ([Uri]$html).AbsoluteUri

$browser = $null
foreach ($exe in 'msedge.exe','chrome.exe') {
  foreach ($hive in 'HKLM:','HKCU:') {
    if (-not $browser) {
      $p = Get-ItemProperty "$hive\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$exe" -ErrorAction SilentlyContinue
      if ($p -and $p.'(default)' -and (Test-Path $p.'(default)')) { $browser = $p.'(default)' }
    }
  }
}

$ws = New-Object -ComObject WScript.Shell
$targets = @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('Programs'), $root)
foreach ($dir in $targets) {
  $lnk = $ws.CreateShortcut((Join-Path $dir ($name + '.lnk')))
  if ($browser) {
    $lnk.TargetPath = $browser
    $lnk.Arguments  = "--app=`"$url`" --start-maximized"
  } else {
    $lnk.TargetPath = $html
  }
  $lnk.IconLocation     = "$ico,0"
  $lnk.WorkingDirectory = $root
  $lnk.Description      = 'Onoseto – editor vzorů na balicí papír'
  $lnk.Save()
}
Write-Host "Hotovo. Zástupce '$name' je na ploše, v nabídce Start a ve složce aplikace."
if (-not $browser) { Write-Host 'Microsoft Edge ani Chrome nebyl nalezen, aplikace se otevře ve výchozím prohlížeči.' }
