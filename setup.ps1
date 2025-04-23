git config --global user.name "Yue JIN"
# git config --global user.email "yuejin13@qq.com"
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
git config --global push.autoSetupRemote true

$paths = @(
    "Documents/PowerShell/Microsoft.PowerShell_profile.ps1", 
    "Documents/PowerShell/profile.ps1", 
    "Documents/PowerShell/powershell.config.json",
    "AppData/Local/nvim/init.lua",
    "AppData/Local/nvim/lazy-lock.json",
    "AppData/Local/pdm/pdm/config.toml",
    "AppData/Roaming/io.github.clash-verge-rev.clash-verge-rev/verge.yaml",
    ".config/clash/cfw-settings.yaml",
    ".docker/daemon.json",
    ".docker/config.json",
    "pip/pip.ini",
    "config.xlaunch",
    ".wslconfig",
    ".npmrc"
)

foreach ($path in $paths) {
    New-Item -Force -Path "~/$path" -ItemType SymbolicLink -Value (Get-Item "./$path").FullName
}

# X forwarding for openssh
[System.Environment]::SetEnvironmentVariable("DISPLAY", "localhost:0", "User")
