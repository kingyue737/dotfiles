# Target directory
$targetDir = "C:\Program Files\deck"

# Create the directory if it doesn't exist
if (-Not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
}

# Fetch the latest release information from GitHub
$release = Invoke-RestMethod https://api.github.com/repos/kong/deck/releases/latest

# Find the latest Windows AMD64 tar.gz asset
$asset = $release.assets |
    Where-Object { $_.name -like "*windows_amd64.tar.gz" } |
    Select-Object -First 1

# Download the asset to the target directory
$outFile = Join-Path $targetDir "deck-latest.tar.gz"
Write-Host "Downloading deck from $($asset.browser_download_url)..."
Invoke-WebRequest $asset.browser_download_url -OutFile $outFile

# Clean up any existing extracted files (optional)
Get-ChildItem $targetDir -Exclude "deck-latest.tar.gz" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# Extract the tarball into the target directory
Write-Host "Extracting deck..."
tar -xzf $outFile -C $targetDir

# Optional: remove the downloaded tar.gz after extraction
Remove-Item $outFile

# Add targetDir to the user PATH if not already present
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$targetDir*") {
    Write-Host "Adding $targetDir to user PATH..."
    $newPath = "$currentPath;$targetDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "PATH updated. You may need to restart PowerShell for changes to take effect."
} else {
    Write-Host "$targetDir is already in the PATH."
}

Write-Host "Deck has been updated to the latest version in $targetDir."