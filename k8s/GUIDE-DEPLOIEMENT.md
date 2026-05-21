# 🚀 Guide de Déploiement EduMaster sur K3s

## 📋 Prérequis

### 1. Cluster K3s configuré
- ✅ 3 VMs: k8s-master, k8s-worker1, k8s-worker2
- ✅ K3s installé sur tous les nœuds
- ✅ kubectl configuré pour accéder au cluster

### 2. Vérifier le cluster
```bash
# Sur votre machine Windows (PowerShell)
ssh user@k8s-master

# Vérifier les nœuds
kubectl get nodes

# Résultat attendu:
# NAME          STATUS   ROLES                  AGE   VERSION
# k8s-master    Ready    control-plane,master   Xd    v1.28.x+k3s1
# k8s-worker1   Ready    <none>                 Xd    v1.28.x+k3s1
# k8s-worker2   Ready    <none>                 Xd    v1.28.x+k3s1
```

---

## 🔧 Étape 1: Transférer les fichiers

### Option A: Via SCP (depuis Windows)
```powershell
# Compresser le dossier k8s
Compress-Archive -Path "C:\Users\amaly\Downloads\plateform-d'apprentissage\plateform-apprentissage\k8s" -DestinationPath "C:\Users\amaly\Downloads\edumaster-k8s.zip"

# Transférer vers le master
scp C:\Users\amaly\Downloads\edumaster-k8s.zip user@k8s-master:~/

# Se connecter au master
ssh user@k8s-master

# Décompresser
unzip edumaster-k8s.zip
cd k8s
```

### Option B: Via Git (recommandé)
```bash
# Sur k8s-master
git clone <votre-repo> edumaster
cd edumaster/k8s
```

---

## 🐳 Étape 2: Build des images Docker

### Option A: Build sur le master (simple)
```bash
# Sur k8s-master
cd ~/k8s
chmod +x BUILD-IMAGES.sh
./BUILD-IMAGES.sh
```

### Option B: Build sur Windows et push vers registry
```powershell
# Sur Windows
cd C:\Users\amaly\Downloads\plateform-d'apprentissage\plateform-apprentissage

# Build toutes les images
docker compose build

# Tag pour le registry K3s
docker tag plateform-apprentissage-course-service edumaster/course-service:latest
docker tag plateform-apprentissage-user-service edumaster/user-service:latest
docker tag plateform-apprentissage-analytics-service edumaster/analytics-service:latest
docker tag plateform-apprentissage-ai-tutor-service edumaster/ai-tutor-service:latest
docker tag plateform-apprentissage-learning-frontend edumaster/frontend:latest
docker tag plateform-apprentissage-n8n-automation edumaster/n8n:latest

# Sauvegarder les images
docker save edumaster/course-service:latest | gzip > course-service.tar.gz
docker save edumaster/user-service:latest | gzip > user-service.tar.gz
docker save edumaster/analytics-service:latest | gzip > analytics-service.tar.gz
docker save edumaster/ai-tutor-service:latest | gzip > ai-tutor-service.tar.gz
docker save edumaster/frontend:latest | gzip > frontend.tar.gz
docker save edumaster/n8n:latest | gzip > n8n.tar.gz

# Transférer vers le master
scp *.tar.gz user@k8s-master:~/images/

# Sur k8s-master, charger les images
ssh user@k8s-master
cd ~/images
for img in *.tar.gz; do
  sudo k3s ctr images import $img
done
```

---

## 💾 Étape 3: Installer Longhorn

```bash
# Sur k8s-master
# Installer Helm si pas déjà fait
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Ajouter le repo Longhorn
helm repo add longhorn https://charts.longhorn.io
helm repo update

# Installer Longhorn
helm install longhorn longhorn/longhorn \
  --namespace longhorn-system \
  --create-namespace \
  --set defaultSettings.defaultReplicaCount=2

# Vérifier l'installation
kubectl get pods -n longhorn-system -w

# Attendre que tous les pods soient Ready (Ctrl+C pour arrêter)
```

---

## 🚀 Étape 4: Déployer EduMaster

```bash
# Sur k8s-master
cd ~/k8s

# Rendre le script exécutable
chmod +x DEPLOY.sh

# Lancer le déploiement
./DEPLOY.sh

# Ou manuellement:
# 1. Namespace
kubectl apply -f namespace.yaml

# 2. ConfigMaps et Secrets
kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml

# 3. StorageClass
kubectl apply -f storage/longhorn-install.yaml

# 4. PVCs
kubectl apply -f storage/

# 5. Bases de données
kubectl apply -f databases/

# Attendre que les BDD soient prêtes
kubectl wait --for=condition=ready pod -l component=database -n edumaster --timeout=300s

# 6. Services backend
kubectl apply -f services/

# 7. Gateway
kubectl apply -f ingress/
```

---

## ✅ Étape 5: Vérifier le déploiement

```bash
# Vérifier tous les pods
kubectl get pods -n edumaster

# Vérifier les services
kubectl get svc -n edumaster

# Vérifier les PVCs
kubectl get pvc -n edumaster

# Vérifier les logs d'un pod
kubectl logs -f <pod-name> -n edumaster

# Obtenir l'IP du nœud
kubectl get nodes -o wide
```

---

## 🌐 Étape 6: Accéder à l'application

### Obtenir l'IP du cluster
```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "IP du cluster: $NODE_IP"
```

### URLs d'accès
- **Frontend EduMaster**: `http://<NODE_IP>:30080`
- **n8n Workflows**: `http://<NODE_IP>:30568`
- **MinIO Console**: `http://<NODE_IP>:30901`

### Depuis Windows
Ouvrez votre navigateur et allez sur:
- `http://192.168.x.x:30080` (remplacez par l'IP de votre master)

---

## 🔍 Commandes utiles

### Surveillance
```bash
# Voir tous les pods en temps réel
watch kubectl get pods -n edumaster

# Logs d'un service
kubectl logs -f deployment/course-service -n edumaster

# Décrire un pod
kubectl describe pod <pod-name> -n edumaster

# Shell dans un pod
kubectl exec -it <pod-name> -n edumaster -- /bin/sh
```

### Mise à jour
```bash
# Redéployer un service après modification de l'image
kubectl rollout restart deployment/course-service -n edumaster

# Voir l'historique des déploiements
kubectl rollout history deployment/course-service -n edumaster

# Rollback
kubectl rollout undo deployment/course-service -n edumaster
```

### Scaling
```bash
# Augmenter le nombre de replicas
kubectl scale deployment/course-service --replicas=3 -n edumaster

# Auto-scaling
kubectl autoscale deployment/course-service --min=2 --max=5 --cpu-percent=80 -n edumaster
```

### Nettoyage
```bash
# Supprimer tout le namespace (ATTENTION: supprime toutes les données)
kubectl delete namespace edumaster

# Supprimer Longhorn
helm uninstall longhorn -n longhorn-system
kubectl delete namespace longhorn-system
```

---

## 🐛 Dépannage

### Pod en CrashLoopBackOff
```bash
kubectl logs <pod-name> -n edumaster --previous
kubectl describe pod <pod-name> -n edumaster
```

### PVC en Pending
```bash
kubectl get pvc -n edumaster
kubectl describe pvc <pvc-name> -n edumaster
kubectl get storageclass
```

### Service inaccessible
```bash
kubectl get svc -n edumaster
kubectl get endpoints -n edumaster
kubectl port-forward svc/<service-name> 8080:8080 -n edumaster
```

### Longhorn issues
```bash
kubectl get pods -n longhorn-system
kubectl logs -n longhorn-system -l app=longhorn-manager
```

---

## 📊 Monitoring (Optionnel)

### Installer Prometheus + Grafana
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace

# Accéder à Grafana
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
# Login: admin / prom-operator
```

---

## 🎯 Checklist de déploiement

- [ ] Cluster K3s opérationnel (3 nœuds)
- [ ] Longhorn installé et fonctionnel
- [ ] Images Docker buildées et disponibles
- [ ] Namespace `edumaster` créé
- [ ] ConfigMaps et Secrets appliqués
- [ ] PVCs créés et Bound
- [ ] Bases de données déployées et Ready
- [ ] Services backend déployés et Ready
- [ ] Frontend déployé et Ready
- [ ] Nginx Gateway déployé et Ready
- [ ] Application accessible via NodePort
- [ ] Tests de connexion réussis

---

## 📞 Support

En cas de problème:
1. Vérifier les logs: `kubectl logs -f <pod-name> -n edumaster`
2. Vérifier les événements: `kubectl get events -n edumaster --sort-by='.lastTimestamp'`
3. Vérifier les ressources: `kubectl top nodes` et `kubectl top pods -n edumaster`
