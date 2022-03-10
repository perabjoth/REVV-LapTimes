$transactionID = Read-Host -Prompt 'Input Transaction ID'
$releases = Invoke-RestMethod -Uri  "https://game-session-api.revvracing.com/v1.0/game/result/$($transactionID)"
$playerID = $releases.players.playerId
$results = $releases.data."$playerID"
$fileData = ""
$results.PSObject.Properties | ForEach-Object {
   $name = $_.Name  -split "_"
   $time = $_.Value/1000
   $lapTime = "$($name): $($time)"
   $fileData = $fileData + $lapTime + "`r`n"
}
$scriptFolder = $MyInvocation.MyCommand.Path | Split-Path -Parent
$fileOutPut = "$($scriptFolder)\$($transactionID).txt"
$fileData | Out-File -FilePath $fileOutPut
Write-Host $fileData
Write-Host "Results created at: $($fileOutPut)"
Read-Host -Prompt 'Press enter to continue'