Set-ExecutionPolicy Bypass -Scope Process -Force
Write-Host "St" -ForegroundColor Green

#CCleaner
Write-Host "`nCCleaner Downloands" -ForegroundColor Cyan
$downloadPath = "$env:USERPROFILE\Downloads\ccsetup.exe"
$ccleanerUrl = "https://download.ccleaner.com/ccsetup.exe"
$OriginalProgressPreference = $ProgressPreference
$ProgressPreference = 'SilentlyContinue'
try {
    Invoke-WebRequest -Uri $ccleanerUrl -OutFile $downloadPath -UseBasicParsing
    Write-Host "Descarcat la: $downloadPath" -ForegroundColor Green
    Start-Process -FilePath $downloadPath -ArgumentList "/S" -Wait
} catch {
    Write-Host "Err" -ForegroundColor Red
    $ProgressPreference = $OriginalProgressPreference
}

#Updateuri
Write-Host "`nWin Updates" -ForegroundColor Cyan
Start-Process "ms-settings:windowsupdate-action"
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
Get-Volume | Where-Object DriveType -eq 'Fixed' | Optimize-Volume -ReTrim -Verbose
Write-Host "`nGata" -ForegroundColor Green
Write-Host "Restart pt updateuri." -ForegroundColor Yellow