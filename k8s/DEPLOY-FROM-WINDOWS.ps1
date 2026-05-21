# =============================================================================
# Script PowerShell pour déployer EduMaster sur K3s depuis Windows
# =============================================================================

param(
    [string]$MasterIP = "192.168.1.100",  # Remplacez par l'IP de votre k8s-master
    [string]$Username = "user"             # Remplacez par votre username SSH
)

Write-Host "🚀 Déploiement EduMaster sur K3s depuis Windows" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Compresser le dossier k8s
Write-Host "📦 Compression des manifestes K8s..." -ForegroundColor Yellow
$sourcePath = "$PSScriptRoot"
$zipPath = "$env:TEMP\edumaster-k8s.zip"

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Compress-Archive -Path $sourcePath\* -DestinationPath $zipPath -Force
Write-Host "✅ Compression terminée: $zipPath" -ForegroundColor Green

# 2. Transférer vers le master
Write-Host ""
Write-Host "📤 Transfert vers k8s-master ($MasterIP)..." -ForegroundColor Yellow
scp $zipPath ${Username}@${MasterIP}:~/edumaster-k8s.zip

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors du transfert SCP" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Transfert terminé" -ForegroundColor Green

# 3. Décompresser et déployer sur le master
Write-Host ""
Write-Host "🚀 Déploiement sur le cluster K3s..." -ForegroundColor Yellow

$deployScript = @"
cd ~
unzip -o edumaster-k8s.zip -d edumaster-k8s
cd edumaster-k8s
chmod +x DEPLOY.sh
./DEPLOY.sh
"@

ssh ${Username}@${MasterIP} $deployScript

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors du déploiement" -ForegroundColor Red
    exit 1
}

# 4. Obtenir l'IP du cluster
Write-Host ""
Write-Host "🌐 Obtention de l'IP du cluster..." -ForegroundColor Yellow
$nodeIP = ssh ${Username}@${MasterIP} "kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type==\"InternalIP\")].address}'"

Write-Host ""
Write-Host "✅ Déploiement terminé !" -ForegroundColor Green
Write-Host "========================" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 URLs d'accès:" -ForegroundColor Cyan
Write-Host "   Frontend:     http://${nodeIP}:30080" -ForegroundColor White
Write-Host "   n8n:          http://${nodeIP}:30568" -ForegroundColor White
Write-Host "   MinIO:        http://${nodeIP}:30901" -ForegroundColor White
Write-Host ""
Write-Host "📊 Pour voir l'état du cluster:" -ForegroundColor Cyan
Write-Host "   ssh ${Username}@${MasterIP}" -ForegroundColor White
Write-Host "   kubectl get pods -n edumaster" -ForegroundColor White
Write-Host ""
