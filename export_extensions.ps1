$ErrorActionPreference = "Stop"

$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$backupDir = Join-Path $scriptDir "vsix_extensions"

if (-not (Test-Path -LiteralPath $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

$extensions = & code --list-extensions --show-versions

foreach ($line in $extensions) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    
    $parts = $line.Trim().Split('@')
    if ($parts.Count -lt 2) { continue }
    
    $id = $parts[0].Trim()
    $version = $parts[1].Trim()
    
    $idParts = $id.Split('.', 2)
    $publisher = $idParts[0]
    $name = $idParts[1]
    
    $dest = Join-Path $backupDir "${id}-${version}.vsix"
    $url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$publisher/vsextensions/$name/$version/vspackage"
    
    # Check if already exported (file exists and is not empty)
    if ((Test-Path -LiteralPath $dest) -and ((Get-Item -LiteralPath $dest).Length -gt 0)) {
        Write-Host "Skipping: $id ($version) - already exported" -ForegroundColor DarkGray
        continue
    }
    
    # Clean up older versions if any exist
    Get-ChildItem -LiteralPath $backupDir -Filter "${id}-*.vsix" -ErrorAction SilentlyContinue | Remove-Item -Force
    
    Write-Host "Downloading: $id ($version)..." -ForegroundColor Cyan
    
    & curl.exe -f -sSL --compressed "$url" -o "$dest"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Saved to $dest" -ForegroundColor Green
    } else {
        Write-Host "  Failed to download $id ($version)" -ForegroundColor Yellow
        if (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Force }
    }
}

Write-Host "All downloads completed. Files are saved in $backupDir" -ForegroundColor Yellow
