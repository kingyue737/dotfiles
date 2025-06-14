. "$profile\..\pnpm.ps1"

function set-proxy {
    $Env:http_proxy = "http://127.0.0.1:7890"; $Env:https_proxy = "http://127.0.0.1:7890"
}

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

# npm mirror for binaries
$env:ELECTRON_MIRROR = 'https://cdn.npmmirror.com/binaries/electron/'
$env:ELECTRON_BUILDER_BINARIES_MIRROR = 'https://cdn.npmmirror.com/binaries/electron-builder-binaries/'
$env:COREPACK_NPM_REGISTRY = 'https://registry.npmmirror.com'
# $env:PLAYWRIGHT_DOWNLOAD_HOST = 'https://cdn.npmmirror.com/binaries/playwright'
$env:CYPRESS_DOWNLOAD_PATH_TEMPLATE = 'https://cdn.npmmirror.com/binaries/cypress/${version}/${platform}-${arch}/cypress.zip'
# [System.Environment]::SetEnvironmentVariable('CYPRESS_DOWNLOAD_PATH_TEMPLATE','https://cdn.npmmirror.com/binaries/cypress/${version}/${platform}-${arch}/cypress.zip',[System.EnvironmentVariableTarget]::Machine)

# zoxide
Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
    })

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