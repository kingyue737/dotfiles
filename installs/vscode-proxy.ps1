$shell = New-Object -ComObject Wscript.Shell

$item = Get-Item "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk"

$lnk = $shell.createShortcut($item.fullname)
$lnk.Arguments = '--proxy-server="http://127.0.0.1:7890"'
$lnk.Save()
