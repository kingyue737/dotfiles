# (Invoke-WebRequest -Uri https://pdm.fming.dev/dev/install-pdm.py -UseBasicParsing).Content | python -

$url = 'https://pdm.fming.dev/dev/install-pdm.py'
[System.Net.HttpWebRequest]$req = [System.Net.WebRequest]::Create($url) -as [System.Net.HttpWebRequest]
[System.Net.HttpWebResponse]$resp = $req.getResponse()
$respStream = $resp.getResponseStream()
$sr = new-object IO.StreamReader($respStream)
$result = $sr.ReadToEnd()
$resp.Close()

Write-Output $result | python -