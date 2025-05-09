Write-Host "---------- Scan en cours ----------" -ForegroundColor Green
Start-Sleep -Seconds 2

$Users = $env:USERNAME

# 1. Clé de registre 
$cle = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$valeurStart = Get-ItemProperty -Path $cle -Name "epibrowserstartup" -ErrorAction SilentlyContinue
$valeurUpdate = Get-ItemProperty -Path $cle -Name "epibrowserupdate" -ErrorAction SilentlyContinue


if ($valeurStart) {
    Write-Host "ALERTE : Valeur trouvee : $($valeur.'epibrowserstartup')" -ForegroundColor Red
    Remove-ItemProperty -Confirm -Path $cle -Name "epibrowserstartup"
    Write-Host "##### Supression effcetue #####" -ForegroundColor Yellow
} else {
    Write-Host "OK : Valeur non trouvee epibrowserstartup." -ForegroundColor Blue
}

if ($valeurUpdate) {
    Write-Host "ALERTE : Valeur trouvee : $($valeur.'epibrowserupdate')" -ForegroundColor Red
    Remove-ItemProperty -Confirm -Path $cle -Name "epibrowserupdate"
    Write-Host "##### Supression effcetue #####" -ForegroundColor Yellow
} else {
    Write-Host "OK : Valeur non trouvee epibrowserupdate." -ForegroundColor Blue
}

# 2. Tâche planifiée
$task = schtasks /query /tn "EpibrowserStartup-S-1-5-21-11257" 2>$null
if ($task) {
    Write-Host "ALERTE : Tache planifiee 'EpiBrowser' detectee" -ForegroundColor Red
    Unregister-ScheduledTask -Confirm "EpibrowserStartup-S-1-5-21-11257"
    Write-Host "##### Supression effcetue #####" -ForegroundColor Yellow
} else {
    Write-Host "OK : Aucune tache planifie 'EpiBrowser'" -ForegroundColor Blue
}

# 3. Dossier EpiSoftware
$localPath = "C:\Users\$Users\AppData\local"
$localFile = Get-ChildItem -Force $localPath
foreach($file in $localFile) {
    if ($file -match "EPISoftware") {
        Write-Host "ALERTE : Dossier EPISoftware detecte -> $StartUpPath\$file" -ForegroundColor Red
        Remove-Item -Confirm -Force -Path "$StartUpPath\$file"
        Write-Host "##### Supression effcetue #####" -ForegroundColor Yellow
    }
}
Write-Host "OK : Aucun fichier 'EpiBrowser'" -ForegroundColor Blue

Write-Host "---------- Scan fini ----------" -ForegroundColor Green
Start-Sleep -Seconds 10
