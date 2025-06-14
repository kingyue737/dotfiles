# KingYue's dotfiles

[![gitmoji](https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg)](https://gitmoji.dev)

```pwsh
winget import -i .\winget.json
```

Open the newly installed PowerShell v7. Then

```pwsh
sudo pwsh .\setup.ps1
```

## VSCode proxy

Add `--proxy-server="http://127.0.0.1:7890"` for VSCode shortcut
https://code.visualstudio.com/docs/setup/network#_proxy-server-support

```pwsh
.\vscode-proxy.ps1
```

## NeoVim

Install im-select to guarantee that im-select.nvim works properly

```sh
.\install-im-select.ps1
```

## Oh My Posh

> https://ohmyposh.dev/docs/installation/fonts

Install a Nerd font

```sh
oh-my-posh font install
```

It seems that CaskaydiaCove NF or Cascadia Code (MS) suits best.

> Make sure that the icons in `omp.json` match the latest Nerd Font.

## Mirrors

Configuring or updating mirrors, please refer to guides of [Tsinghua Tuna Mirror](https://mirror.tuna.tsinghua.edu.cn/help/AOSP/).

## Others

Due to https://github.com/pnpm/pnpm/issues/7293, you may need to set the path of pnpm manually:

```
~\AppData\Local\Microsoft\WinGet\Packages\pnpm.pnpm_Microsoft.Winget.Source_8wekyb3d8bbwe
```
