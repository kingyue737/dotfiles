. "$profile\..\pnpm.ps1"

# function set-proxy {
#     $Env:http_proxy = "http://127.0.0.1:7890"; $Env:https_proxy = "http://127.0.0.1:7890"
# }

function cdlnk($target) {
    if ($target.EndsWith(".lnk")) {
        $sh = new-object -com wscript.shell
        $fullpath = resolve-path $target
        $targetpath = $sh.CreateShortcut($fullpath).TargetPath
        set-location $targetpath
    }
    else {
        set-location $target
    }
}

function refreshenv {
    $env:path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") 
}

function set-pnpm-path {
    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
    $newPath = "\AppData\Local\Microsoft\WinGet\Packages\pnpm.pnpm_Microsoft.Winget.Source_8wekyb3d8bbwe"
    $updatedPath = "$currentPath;$env:USERPROFILE$newPath"
    [System.Environment]::SetEnvironmentVariable("Path", $updatedPath, [System.EnvironmentVariableTarget]::User)
}

function Refresh-NpmToken {
    Write-Host "🔄 Fetching NPM token from 1Password..." -ForegroundColor Cyan

    # Read the token via 1Password CLI using the secret reference
    $Token = op read "op://Shared/bfojwj2lryfxdo5mn7v6uwavii/Section_8CC92BBEFAC0417D9C5571F81718CE7D/qsp4cgbsolp2ok7qn4d2ac7sfe"

    if ([string]::IsNullOrWhiteSpace($Token)) {
        Write-Host "❌ Failed to get token. Please check if 1Password is unlocked and the reference path is correct." -ForegroundColor Red
        return
    }

    # 1. Persist the token to Windows User Scope environment variables
    [Environment]::SetEnvironmentVariable("NPM_TOKEN", $Token, "User")

    # 2. Inject the token into the current terminal session for immediate use
    $env:NPM_TOKEN = $Token

    Write-Host "✅ NPM_TOKEN has been permanently written to User Scope and is active in the current session!" -ForegroundColor Green
}

function Remove-NodeModules {
    # Only run in project root (must have package.json)
    $packageJson = Get-Item "package.json" -ErrorAction SilentlyContinue
    if (-not $packageJson) {
        Write-Host "❌ Not in a project root (package.json not found)" -ForegroundColor Red
        return
    }

    $dirs = Get-ChildItem -Path . -Filter "node_modules" -Recurse -Directory
    if (-not $dirs) {
        Write-Host "✅ No node_modules found" -ForegroundColor Green
        return
    }

    Write-Host "Found $($dirs.Count) node_modules, removing..." -ForegroundColor Yellow
    $dirs | Remove-Item -Recurse -Force
    Write-Host "✅ Done" -ForegroundColor Green
}

function Clear-MergedBranches {
    <#
    .SYNOPSIS
        一键清除当前 Git 仓库中已合并到主分支的本地分支。
    .PARAMETER Base
        作为“已合并”判断基准的分支，默认自动检测 main/master。
    .PARAMETER Force
        跳过确认直接删除。
    .PARAMETER WhatIf
        仅列出将被删除的分支，不实际删除。
    #>
    param(
        [string]$Base,
        [switch]$Force,
        [switch]$WhatIf
    )

    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Error "当前目录不是 Git 仓库。"
        return
    }

    if (-not $Base) {
        $Base = @('main', 'master') | Where-Object {
            git show-ref --verify --quiet "refs/heads/$_"
            $LASTEXITCODE -eq 0
        } | Select-Object -First 1
        if (-not $Base) {
            Write-Error "未找到 main/master 分支，请用 -Base 指定基准分支。"
            return
        }
    }

    $current = git rev-parse --abbrev-ref HEAD

    $mergedSet = @{}
    git branch --merged $Base |
        ForEach-Object { $_.Trim().TrimStart('* ').Trim() } |
        Where-Object { $_ } |
        ForEach-Object { $mergedSet[$_] = $true }

    $allBranches = git branch --format='%(refname:short)' |
        Where-Object { $_ -and $_ -ne $Base -and $_ -ne $current }

    # 普通合并(fast-forward可识别)用 -d 删除即可；
    # squash 合并后 git 看不出祖先关系，需用下面的“影子commit + git cherry”
    # 技巧按内容比对，识别后用 -D 强制删除。
    $toDelete = @()
    foreach ($branch in $allBranches) {
        if ($mergedSet.ContainsKey($branch)) {
            $toDelete += [pscustomobject]@{ Name = $branch; Method = 'merged' }
            continue
        }

        $mergeBase = git merge-base $Base $branch 2>$null
        if (-not $mergeBase) { continue }
        $tree = git rev-parse "$branch^{tree}" 2>$null
        $dummy = git commit-tree $tree -p $mergeBase -m "_" 2>$null
        if (-not $dummy) { continue }
        $cherry = git cherry $Base $dummy 2>$null
        if ($cherry -match '^-') {
            $toDelete += [pscustomobject]@{ Name = $branch; Method = 'squash' }
        }
    }

    if (-not $toDelete) {
        Write-Host "没有可清理的已合并分支。" -ForegroundColor Green
        return
    }

    Write-Host "以下分支已合并到 '$Base'，将被删除：" -ForegroundColor Yellow
    $toDelete | ForEach-Object {
        $tag = if ($_.Method -eq 'squash') { '(squash)' } else { '(merged)' }
        Write-Host "  $($_.Name) $tag"
    }

    if ($WhatIf) {
        return
    }

    if (-not $Force) {
        $confirm = Read-Host "确认删除以上分支？(y/N)"
        if ($confirm -ne 'y' -and $confirm -ne 'Y') {
            Write-Host "已取消。" -ForegroundColor Cyan
            return
        }
    }

    foreach ($item in $toDelete) {
        if ($item.Method -eq 'squash') {
            git branch -D $item.Name
        } else {
            git branch -d $item.Name
        }
    }
}

function ghapprove {
    param([string]$PrUrl)
    gh pr review $PrUrl --approve
}

# Google Cloud Project ID for Gemini CLI
# $env:GOOGLE_CLOUD_PROJECT = 'ai-trial-455208'
# npm mirror for binaries
# $env:ELECTRON_MIRROR = 'https://cdn.npmmirror.com/binaries/electron/'
# $env:ELECTRON_BUILDER_BINARIES_MIRROR = 'https://cdn.npmmirror.com/binaries/electron-builder-binaries/'
# $env:COREPACK_NPM_REGISTRY = 'https://registry.npmmirror.com'
# $env:PLAYWRIGHT_DOWNLOAD_HOST = 'https://cdn.npmmirror.com/binaries/playwright'
# $env:CYPRESS_DOWNLOAD_PATH_TEMPLATE = 'https://cdn.npmmirror.com/binaries/cypress/${version}/${platform}-${arch}/cypress.zip'
# [System.Environment]::SetEnvironmentVariable('CYPRESS_DOWNLOAD_PATH_TEMPLATE','https://cdn.npmmirror.com/binaries/cypress/${version}/${platform}-${arch}/cypress.zip',[System.EnvironmentVariableTarget]::Machine)

# https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory#powershell-powershellexe-or-pwshexe
function prompt {
    $loc = $executionContext.SessionState.Path.CurrentLocation;

    $out = "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
    if ($loc.Provider.Name -eq "FileSystem") {
        $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
    }
    return $out
}

# winget completion https://learn.microsoft.com/en-us/windows/package-manager/winget/tab-completion#enable-tab-completion
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# Import the PSFzf module to enable its commands
Import-Module PSFzf
Set-PSFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

Import-Module posh-git