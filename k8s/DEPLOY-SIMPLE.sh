#!/bin/bash
# =============================================================================
# Script de déploiement simplifié EduMaster sur K3s
# À exécuter après l'installation de Longhorn
# =============================================================================

set -e

echo "🚀 Déploiement EduMaster sur K3s"
echo "=================================="
echo ""

cd ~/edumaster/k8s

# 1. Créer le namespace
echo "📦 Étape 1/7: Création du namespace..."
kubectl apply -f namespace.yaml
echo "✅ Namespace créé"
echo ""

# 2. Créer ConfigMaps et Secrets
echo "🔧 Étape 2/7: Configuration des variables..."
kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml
echo "✅ Configuration appliquée"
echo ""

# 3. Appliquer StorageClass
echo "💾 Étape 3/7: Configuration du stockage..."
kubectl apply -f storage/longhorn-install.yaml
echo "✅ StorageClass configuré"
echo ""

# 4. Créer les PVCs
echo "💾 Étape 4/7: Création des volumes persistants..."
kubectl apply -f storage/pvc-postgres.yaml
kubectl apply -f storage/pvc-mongodb.yaml
kubectl apply -f storage/pvc-redis.yaml
kubectl apply -f storage/pvc-minio.yaml
kubectl apply -f storage/pvc-n8n.yaml
echo "✅ PVCs créés"
echo ""

# Attendre que les PVCs soient Bound
echo "⏳ Attente du provisionnement des volumes..."
sleep 10
kubectl get pvc -n edumaster
echo ""

# 5. Déployer les bases de données
echo "🗄️  Étape 5/7: Déploiement des bases de données..."
kubectl apply -f databases/
echo "✅ Bases de données déployées"
echo ""

# Attendre que les BDD soient prêtes
echo "⏳ Attente des bases de données (2 min)..."
sleep 120

# 6. Déployer les services backend
echo "⚙️  Étape 6/7: Déploiement des services backend..."
kubectl apply -f services/
echo "✅ Services backend déployés"
echo ""

# 7. Déployer Nginx Gateway
echo "🌐 Étape 7/7: Déploiement du gateway..."
kubectl apply -f ingress/
echo "✅ Gateway déployé"
echo ""

# Afficher l'état
echo "========================================="
echo "✅ DÉPLOIEMENT TERMINÉ !"
echo "========================================="
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
echo ""
echo "📝 Pour voir les logs d'un service:"
echo "   kubectl logs -f deployment/<service-name> -n edumaster"
echo ""
