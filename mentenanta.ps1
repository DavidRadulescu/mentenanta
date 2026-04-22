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

#BitDefender 
Write-Host "`nBitdefender" -ForegroundColor Cyan 
$bdConsole = "$env:C:\Program Files\Bitdefender\Endpoint Security\product.console.exe"
if (Test-Path $bdConsole){
    Write-Host "Porneste scanarea" -ForegroundColor Green
    & $bdConsole /c FileScan.OnDemand.RunScanTask full
    Write-Host "A pornit scanarea, de verificat progres manual" -ForegroundColor Yellow 
}
else {
    Write-Host "Nu a gasit bitdefender" -ForegroundColor Red
}

#Updateuri
Write-Host "`nWin Updates" -ForegroundColor Cyan
Start-Process "ms-settings:windowsupdate"
Write-Host "Vezi fereastra" -ForegroundColor Green

<#Winget upgrade --all dar fara sa iti ceara confirmare pentru fiecare pachet (toate tagurile dupa --all sunt responsabile, de adaugat comentarii la ele daca nu se doresc)
In caz de eroare la sursa pentru winget, I.E 'Source is outdated' trebuie sa se ruleze winget source reset --force inainte si dupa sa fie rulat din nou #>
Write-Host "`nWinget" -ForegroundColor Cyan 
winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
Write-Host "Gata cu winget" -ForegroundColor Green 

#Office 
Write-Host "`nUpdate suita Office" -ForegroundColor Cyan 
$officeC2R = "$env:ProgramFiles\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe"
if (Test-Path $officeC2R) {
    Write-Host "Pornire update Office" -ForegroundColor Green
    Start-Process -FilePath $officeC2R -ArgumentList "/update user displaylevel=true forceappshutdown=false" 
    Write-Host "Vezi fereastra Office" -ForegroundColor Green
} else {
    Write-Host "Office c2r nu a fost gasita" -ForegroundColor Yellow
}

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