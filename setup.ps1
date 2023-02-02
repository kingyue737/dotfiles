git config --global user.name "Yue JIN"
# git config --global user.email "yuejin13@qq.com"
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

$paths = @(
    "Documents/PowerShell/Microsoft.PowerShell_profile.ps1", 
    "Documents/PowerShell/profile.ps1", 
    "Documents/PowerShell/powershell.config.json",
    ".config/clash/cfw-settings.yaml",
    ".docker/daemon.json",
    "pip/pip.ini",
    "config.xlaunch",
    ".wslconfig",
    ".npmrc"
)

foreach ($path in $paths) {
    New-Item -Force -Path "~/$path" -ItemType SymbolicLink -Value (Get-Item "./$path").FullName
}