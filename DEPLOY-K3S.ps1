# =============================================================================
# Script de déploiement EduMaster sur K3s depuis Windows
# =============================================================================

Write-Host "🚀 Déploiement EduMaster sur K3s" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$K8S_MASTER = "192.168.9.10"
$K8S_USER = "k8sadmin"
$LOCAL_PATH = "C:\Users\amaly\Downloads\plateform-d'apprentissage\plateform-apprentissage"

# Étape 1: Transférer le fichier zip
Write-Host "📦 Étape 1/5: Transfert des fichiers vers k8s-master..." -ForegroundColor Yellow
scp "$LOCAL_PATH\edumaster-k8s.zip" "${K8S_USER}@${K8S_MASTER}:~/"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors du transfert SCP" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Fichiers transférés avec succès" -ForegroundColor Green
Write-Host ""

# Étape 2: Décompresser et préparer
Write-Host "📂 Étape 2/5: Décompression des fichiers..." -ForegroundColor Yellow
ssh "${K8S_USER}@${K8S_MASTER}" @"
    unzip -o ~/edumaster-k8s.zip -d ~/
    cd ~/k8s
    chmod +x *.sh
    echo '✅ Fichiers décompressés'
"@

Write-Host "✅ Fichiers prêts" -ForegroundColor Green
Write-Host ""

# Étape 3: Installer Longhorn
Write-Host "💾 Étape 3/5: Installation de Longhorn..." -ForegroundColor Yellow
ssh "${K8S_USER}@${K8S_MASTER}" @"
    # Installer Helm si nécessaire
    if ! command -v helm &> /dev/null; then
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    fi
    
    # Installer Longhorn
    helm repo add longhorn https://charts.longhorn.io 2>/dev/null || true
    helm repo update
    
    helm upgrade --install longhorn longhorn/longhorn \
        --namespace longhorn-system \
        --create-namespace \
        --set defaultSettings.defaultReplicaCount=2 \
        --wait --timeout=10m
    
    echo '✅ Longhorn installé'
"@

Write-Host "✅ Longhorn opérationnel" -ForegroundColor Green
Write-Host ""

# Étape 4: Déployer EduMaster
Write-Host "🚀 Étape 4/5: Déploiement d'EduMaster..." -ForegroundColor Yellow
ssh "${K8S_USER}@${K8S_MASTER}" @"
    cd ~/k8s
    ./DEPLOY.sh
"@

Write-Host "✅ EduMaster déployé" -ForegroundColor Green
Write-Host ""

# Étape 5: Afficher les informations d'accès
Write-Host "🌐 Étape 5/5: Récupération des informations d'accès..." -ForegroundColor Yellow
$NODE_IP = ssh "${K8S_USER}@${K8S_MASTER}" "kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type==\"InternalIP\")].address}'"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ DÉPLOIEMENT TERMINÉ AVEC SUCCÈS !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 URLs d'accès:" -ForegroundColor Cyan
Write-Host "   Frontend EduMaster: http://${NODE_IP}:30080" -ForegroundColor White
Write-Host "   n8n Workflows:      http://${NODE_IP}:30568" -ForegroundColor White
Write-Host "   MinIO Console:      http://${NODE_IP}:30901" -ForegroundColor White
Write-Host ""
Write-Host "📊 Pour voir l'état des pods:" -ForegroundColor Cyan
Write-Host "   ssh ${K8S_USER}@${K8S_MASTER}" -ForegroundColor White
Write-Host "   kubectl get pods -n edumaster" -ForegroundColor White
Write-Host ""
Write-Host "🔍 Pour voir les logs d'un service:" -ForegroundColor Cyan
Write-Host "   kubectl logs -f deployment/course-service -n edumaster" -ForegroundColor White
Write-Host ""
