#!/bin/bash
# =============================================================================
# Script à copier-coller dans le terminal de k8s-master
# Crée tous les fichiers nécessaires pour le déploiement EduMaster
# =============================================================================

echo "🚀 Création des fichiers de déploiement EduMaster..."

# Créer la structure
mkdir -p ~/edumaster/k8s/{storage,databases,services,ingress}
cd ~/edumaster/k8s

# ============= namespace.yaml =============
cat > namespace.yaml << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: edumaster
  labels:
    name: edumaster
    environment: production
EOF

# ============= configmap.yaml =============
cat > configmap.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: edumaster-config
  namespace: edumaster
data:
  POSTGRES_HOST: "postgres-service"
  POSTGRES_PORT: "5432"
  POSTGRES_DB: "lms_courses"
  MONGODB_HOST: "mongodb-service"
  MONGODB_PORT: "27017"
  MONGODB_DB: "lms_users"
  REDIS_HOST: "redis-service"
  REDIS_PORT: "6379"
  COURSE_SERVICE_URL: "http://course-service:8001"
  USER_SERVICE_URL: "http://user-service:8002"
  ANALYTICS_SERVICE_URL: "http://analytics-service:8003"
  AI_TUTOR_SERVICE_URL: "http://ai-tutor-service:8004"
  N8N_WEBHOOK_BASE_URL: "http://n8n-service:5678"
  WEBHOOK_URL: "http://n8n-service:5678"
  MINIO_ENDPOINT: "minio-service:9000"
  MINIO_CONSOLE_ADDRESS: ":9001"
  OPENAI_BASE_URL: "http://host.docker.internal:11434/v1"
  LLM_MODEL: "llama3.2"
EOF

# ============= secrets.yaml =============
cat > secrets.yaml << 'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: edumaster-secrets
  namespace: edumaster
type: Opaque
stringData:
  POSTGRES_USER: "lms_user"
  POSTGRES_PASSWORD: "lms_password"
  JWT_SECRET: "your-secret-key-change-in-production"
  MINIO_ROOT_USER: "admin"
  MINIO_ROOT_PASSWORD: "Admin@2026!Secure"
  N8N_EMAIL: "admin@edumaster.com"
  N8N_PASSWORD: "Amal123@"
  OPENAI_API_KEY: ""
  GROQ_API_KEY: ""
EOF

# ============= storage/longhorn-install.yaml =============
cat > storage/longhorn-install.yaml << 'EOF'
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: longhorn
provisioner: driver.longhorn.io
allowVolumeExpansion: true
reclaimPolicy: Retain
volumeBindingMode: Immediate
parameters:
  numberOfReplicas: "2"
  staleReplicaTimeout: "2880"
  fromBackup: ""
  fsType: "ext4"
EOF

# ============= storage/pvc-postgres.yaml =============
cat > storage/pvc-postgres.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: edumaster
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: longhorn
  resources:
    requests:
      storage: 5Gi
EOF

# ============= storage/pvc-mongodb.yaml =============
cat > storage/pvc-mongodb.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-pvc
  namespace: edumaster
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: longhorn
  resources:
    requests:
      storage: 5Gi
EOF

# ============= storage/pvc-redis.yaml =============
cat > storage/pvc-redis.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis-pvc
  namespace: edumaster
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: longhorn
  resources:
    requests:
      storage: 1Gi
EOF

# ============= storage/pvc-minio.yaml =============
cat > storage/pvc-minio.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: minio-pvc
  namespace: edumaster
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: longhorn
  resources:
    requests:
      storage: 10Gi
EOF

# ============= storage/pvc-n8n.yaml =============
cat > storage/pvc-n8n.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: n8n-pvc
  namespace: edumaster
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: longhorn
  resources:
    requests:
      storage: 2Gi
EOF

echo "✅ Fichiers de configuration créés"
echo "📂 Dossier: ~/edumaster/k8s"
echo ""
echo "Prochaine étape: Installer Longhorn"
echo "Exécutez: curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
