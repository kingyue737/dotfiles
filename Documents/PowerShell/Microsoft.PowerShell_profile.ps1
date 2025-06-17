# https://ohmyposh.dev/docs/faq#my-prompt-is-broken-after-upgrading-to-powershell-74
[Console]::OutputEncoding = [Text.Encoding]::UTF8
oh-my-posh init pwsh --config "$env:USERPROFILE/omp.json" | Invoke-Expression

# zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })