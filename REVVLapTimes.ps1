$transactionID = Read-Host -Prompt 'Input Transaction ID'
$releases = Invoke-RestMethod -Uri  "https://game-session-api.revvracing.com/v1.0/game/result/$($transactionID)"
$playerID = $releases.players.playerId
$results = $releases.result."$playerID".laps
$fileData = ""
$lapTimes = ""
$lapCount = 1
$newline = "`r`n"
Foreach ($i in $results) {
   $lapTime = $i.time
   $lapTime = [timespan]::fromseconds($lapTime / 1000)
   $lapTime = ("{0:mm\:ss\.fff}" -f $lapTime)
   $sectorCount = 1
   $lapTimes = $lapTimes + "Lap " + $lapCount + ": " + $lapTime + $newline
   Foreach ($j in $i.sectors) {
      $sectorTime = $j / 1000
      $fileData = $fileData + "Lap " + $lapCount + " Sector " + $sectorCount + ": " + $sectorTime + $newline
      $sectorCount = $sectorCount + 1
   }
   $lapCount = $lapCount + 1
}
$fileData = $lapTimes + $fileData
$scriptFolder = $MyInvocation.MyCommand.Path | Split-Path -Parent
$fileOutPut = "$($scriptFolder)\$($transactionID).txt"
$fileData | Out-File -FilePath $fileOutPut
Write-Host $fileData
Write-Host "Results created at: $($fileOutPut)"
Read-Host -Prompt 'Press enter to continue'