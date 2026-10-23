$ErrorActionPreference = "Stop"

$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$backupDir = Join-Path $scriptDir "vsix_extensions"

if (-not (Test-Path -LiteralPath $backupDir)) {
    Write-Host "Error: Directory $backupDir not found." -ForegroundColor Red
    exit 1
}

$vsixFiles = Get-ChildItem -LiteralPath $backupDir -Filter "*.vsix"

if ($vsixFiles.Count -eq 0) {
    Write-Host "No .vsix files found in $backupDir." -ForegroundColor Yellow
    exit 0
}

foreach ($file in $vsixFiles) {
    Write-Host "Installing: $($file.Name)..." -ForegroundColor Cyan
    & code --install-extension "$($file.FullName)" --force
}

Write-Host "All extensions installed successfully." -ForegroundColor Green
