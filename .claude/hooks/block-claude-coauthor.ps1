$json = [Console]::In.ReadToEnd()
if ($json -notmatch 'git\s+commit') { exit 0 }

$patterns = @(
    'Co-Authored-By:\s*Claude',
    'noreply@anthropic\.com',
    'Generated with[^"]*Claude Code'
)
foreach ($p in $patterns) {
    if ($json -match $p) {
        [Console]::Error.WriteLine("Refusing commit: Claude/Anthropic attribution trailer is not allowed. Remove the 'Co-Authored-By: Claude' line and any 'Generated with Claude Code' footer, then retry.")
        exit 2
    }
}
exit 0
