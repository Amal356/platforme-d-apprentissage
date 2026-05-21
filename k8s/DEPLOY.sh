#!/bin/bash
# =============================================================================
# Script de déploiement EduMaster sur K3s
# =============================================================================

set -e

echo "🚀 Déploiement EduMaster sur K3s"
echo "=================================="

# 1. Créer le namespace
echo "📦 Création du namespace..."
kubectl apply -f namespace.yaml

# 2. Installer Longhorn (si pas déjà installé)
echo "💾 Installation de Longhorn..."
helm repo add longhorn https://charts.longhorn.io 2>/dev/null || true
helm repo update
helm upgrade --install longhorn longhorn/longhorn \
  --namespace longhorn-system \
  --create-namespace \
  --set defaultSettings.defaultReplicaCount=2

echo "⏳ Attente de Longhorn..."
kubectl wait --for=condition=ready pod -l app=longhorn-manager -n longhorn-system --timeout=300s

# 3. Appliquer StorageClass
echo "💾 Configuration du stockage..."
kubectl apply -f storage/longhorn-install.yaml

# 4. Créer ConfigMaps et Secrets
echo "🔧 Configuration des variables..."
kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml

# 5. Créer les PVCs
echo "💾 Création des volumes persistants..."
kubectl apply -f storage/pvc-postgres.yaml
kubectl apply -f storage/pvc-mongodb.yaml
kubectl apply -f storage/pvc-redis.yaml
kubectl apply -f storage/pvc-minio.yaml
kubectl apply -f storage/pvc-n8n.yaml

# 6. Déployer les bases de données
echo "🗄️  Déploiement des bases de données..."
kubectl apply -f databases/postgres-deployment.yaml
kubectl apply -f databases/mongodb-deployment.yaml
kubectl apply -f databases/redis-deployment.yaml
kubectl apply -f databases/minio-deployment.yaml

echo "⏳ Attente des bases de données..."
kubectl wait --for=condition=ready pod -l app=postgres -n edumaster --timeout=300s
kubectl wait --for=condition=ready pod -l app=mongodb -n edumaster --timeout=300s
kubectl wait --for=condition=ready pod -l app=redis -n edumaster --timeout=300s
kubectl wait --for=condition=ready pod -l app=minio -n edumaster --timeout=300s

# 7. Déployer les services backend
echo "⚙️  Déploiement des services backend..."
kubectl apply -f services/course-service-deployment.yaml
kubectl apply -f services/user-service-deployment.yaml
kubectl apply -f services/analytics-service-deployment.yaml
kubectl apply -f services/ai-tutor-service-deployment.yaml
kubectl apply -f services/n8n-deployment.yaml

echo "⏳ Attente des services backend..."
sleep 30

# 8. Déployer le frontend
echo "🎨 Déploiement du frontend..."
kubectl apply -f services/frontend-deployment.yaml

# 9. Déployer Nginx Gateway
echo "🌐 Déploiement du gateway..."
kubectl apply -f ingress/nginx-configmap.yaml
kubectl apply -f ingress/nginx-deployment.yaml

echo "⏳ Attente du gateway..."
kubectl wait --for=condition=ready pod -l app=nginx-gateway -n edumaster --timeout=300s

# 10. Afficher l'état
echo ""
echo "✅ Déploiement terminé !"
echo "======================="
echo ""
echo "📊 État des pods:"
kubectl get pods -n edumaster
echo ""
echo "🌐 Services exposés:"
kubectl get svc -n edumaster
echo ""
echo "💾 Volumes persistants:"
kubectl get pvc -n edumaster
echo ""
echo "🔗 Accès à l'application:"
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "   Frontend: http://$NODE_IP:30080"
echo "   n8n:      http://$NODE_IP:30568"
echo "   MinIO:    http://$NODE_IP:30901"
