Set-ExecutionPolicy Bypass -Scope Process -Force
Write-Host "St" -ForegroundColor Green

#CleanUp
Write-Host "`nDisk Cleanup" -ForegroundColor Cyan
$runNumber = 1234
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
$itemsToClean = @(
    "Temporary Files", 
    "Thumbnail Cache", 
    "Downloaded Program Files", 
    "Internet Cache Files"
)
foreach ($item in $itemsToClean) {
    $keyPath = "$registryPath\$item"
    if (Test-Path $keyPath) {
        Set-ItemProperty -Path $keyPath -Name "StateFlags$runNumber" -Value 2 -Type DWord -ErrorAction SilentlyContinue
    }
}
Write-Host "Stergere" -ForegroundColor Cyan
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:$runNumber" -Wait
Write-Host "OK" -ForegroundColor Green

#Updateuri
Write-Host "`nWin Updates" -ForegroundColor Cyan
Start-Process "ms-settings:windowsupdate"
Write-Host "Vezi fereastra" -ForegroundColor Green

#Comenzi cmd
Write-Host "`ncmd" -ForegroundColor Cyan
#TEMP
Write-Host "TEMP" -ForegroundColor Cyan
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "OK" -ForegroundColor Green
#DISM
Write-Host "DISM" -ForegroundColor Cyan
DISM /Online /Cleanup-Image /RestoreHealth
#SFC
Write-Host "SFC" -ForegroundColor Cyan 
sfc /scannow

#SSD
Write-Host "`nSSD opt" -ForegroundColor Cyan
Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' -and $_.DriveLetter } | Optimize-Volume -ReTrim -Verbose
Write-Host "`nGata" -ForegroundColor Green
Write-Host "Restart pt updateuri." -ForegroundColor Yellow
