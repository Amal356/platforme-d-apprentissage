# 🚀 Déploiement Manuel sur K3s - Étape par Étape

## 📋 Prérequis
- VMs K3s démarrées dans VMware
- Accès console aux VMs (via VMware)

---

## 🔧 Étape 1: Préparer les fichiers sur Windows

### 1.1 Compresser le dossier k8s
```powershell
# Dans PowerShell Windows
cd C:\Users\amaly\Downloads\plateform-d'apprentissage\plateform-apprentissage
Compress-Archive -Path k8s\* -DestinationPath k8s-deploy.zip -Force
```

### 1.2 Copier sur une clé USB ou partage réseau
- Copiez `k8s-deploy.zip` sur une clé USB
- Ou utilisez un partage réseau VMware

---

## 💻 Étape 2: Sur la VM k8s-master

### 2.1 Ouvrir la console VMware
1. Dans VMware Workstation, double-cliquez sur **k8s-master**
2. Connectez-vous (root ou votre user)

### 2.2 Transférer le fichier
**Option A - Via clé USB:**
```bash
# Monter la clé USB
mkdir /mnt/usb
mount /dev/sdb1 /mnt/usb
cp /mnt/usb/k8s-deploy.zip ~/
umount /mnt/usb
```

**Option B - Via wget (si vous avez un serveur web):**
```bash
# Depuis Windows, démarrez un serveur web simple:
# python -m http.server 8000
# Puis sur la VM:
wget http://IP_WINDOWS:8000/k8s-deploy.zip
```

**Option C - Via partage VMware:**
```bash
# Si vous avez activé le partage de dossiers VMware
cp /mnt/hgfs/Shared/k8s-deploy.zip ~/
```

### 2.3 Décompresser
```bash
cd ~
unzip k8s-deploy.zip -d k8s
cd k8s
```

---

## 🚀 Étape 3: Installer Longhorn

```bash
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

# Attendre que Longhorn soit prêt (2-3 minutes)
kubectl get pods -n longhorn-system -w
# Appuyez sur Ctrl+C quand tous les pods sont Running
```

---

## 📦 Étape 4: Déployer EduMaster

```bash
# Rendre le script exécutable
chmod +x DEPLOY.sh

# Lancer le déploiement
./DEPLOY.sh

# Ou manuellement:
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml
kubectl apply -f storage/
kubectl apply -f databases/
sleep 60  # Attendre les bases de données
kubectl apply -f services/
kubectl apply -f ingress/
```

---

## ✅ Étape 5: Vérifier le déploiement

```bash
# Voir tous les pods
kubectl get pods -n edumaster

# Voir les services
kubectl get svc -n edumaster

# Voir les volumes
kubectl get pvc -n edumaster

# Obtenir l'IP du nœud
kubectl get nodes -o wide
```

---

## 🌐 Étape 6: Accéder à l'application

### Depuis la VM k8s-master
```bash
# Tester localement
curl http://localhost:30080
```

### Depuis Windows
Ouvrez votre navigateur:
- **Frontend**: `http://192.168.226.128:30080`
- **n8n**: `http://192.168.226.128:30568`
- **MinIO**: `http://192.168.226.128:30901`

---

## 🔍 Commandes de dépannage

### Voir les logs d'un pod
```bash
# Lister les pods
kubectl get pods -n edumaster

# Voir les logs
kubectl logs <nom-du-pod> -n edumaster

# Suivre les logs en temps réel
kubectl logs -f <nom-du-pod> -n edumaster
```

### Redémarrer un service
```bash
kubectl rollout restart deployment/frontend -n edumaster
```

### Supprimer et recommencer
```bash
kubectl delete namespace edumaster
./DEPLOY.sh
```

### Vérifier Longhorn
```bash
kubectl get pods -n longhorn-system
kubectl get storageclass
```

---

## 📝 Alternative: Déploiement pas à pas

Si le script DEPLOY.sh ne fonctionne pas, voici les commandes une par une:

```bash
# 1. Namespace
kubectl apply -f namespace.yaml

# 2. Configuration
kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml

# 3. StorageClass
kubectl apply -f storage/longhorn-install.yaml

# 4. PVCs
kubectl apply -f storage/pvc-postgres.yaml
kubectl apply -f storage/pvc-mongodb.yaml
kubectl apply -f storage/pvc-redis.yaml
kubectl apply -f storage/pvc-minio.yaml
kubectl apply -f storage/pvc-n8n.yaml

# 5. Bases de données
kubectl apply -f databases/postgres-deployment.yaml
kubectl apply -f databases/mongodb-deployment.yaml
kubectl apply -f databases/redis-deployment.yaml
kubectl apply -f databases/minio-deployment.yaml

# Attendre 2 minutes
sleep 120

# 6. Services backend
kubectl apply -f services/course-service-deployment.yaml
kubectl apply -f services/user-service-deployment.yaml
kubectl apply -f services/analytics-service-deployment.yaml
kubectl apply -f services/ai-tutor-service-deployment.yaml
kubectl apply -f services/n8n-deployment.yaml
kubectl apply -f services/frontend-deployment.yaml

# 7. Gateway
kubectl apply -f ingress/nginx-configmap.yaml
kubectl apply -f ingress/nginx-deployment.yaml

# 8. Vérifier
kubectl get pods -n edumaster
```

---

## 🎯 Checklist

- [ ] VMs K3s démarrées
- [ ] Fichier k8s-deploy.zip transféré sur k8s-master
- [ ] Longhorn installé et opérationnel
- [ ] Script DEPLOY.sh exécuté
- [ ] Tous les pods en état Running
- [ ] Application accessible depuis Windows

---

## 💡 Astuce

Si vous ne pouvez pas transférer de fichiers, vous pouvez aussi:
1. Cloner le repo Git directement sur la VM
2. Ou copier-coller le contenu des fichiers YAML un par un
