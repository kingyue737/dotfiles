$paths = @(
    "Documents/PowerShell/Microsoft.PowerShell_profile.ps1", 
    "Documents/PowerShell/profile.ps1", 
    "Documents/PowerShell/pnpm.ps1", 
    "Documents/PowerShell/powershell.config.json",
    "AppData/Local/nvim/init.lua",
    "AppData/Local/nvim/lazy-lock.json",
    # "AppData/Roaming/io.github.clash-verge-rev.clash-verge-rev/verge.yaml",
    # ".docker/daemon.json",
    # ".docker/config.json",
    "pip/pip.ini",
    ".wslconfig",
    ".gitignore_global",
    ".npmrc",
    "omp.json"
)

foreach ($path in $paths) {
    New-Item -Force -Path "~/$path" -ItemType SymbolicLink -Value (Get-Item "./$path").FullName
}

# X forwarding for openssh
[System.Environment]::SetEnvironmentVariable("DISPLAY", "localhost:0", "User")

# Node.js may run out of memory while Vite is building big project
[System.Environment]::SetEnvironmentVariable("NODE_OPTIONS", "--max-old-space-size=8192", "User")
