#!/bin/bash
# =============================================================================
# Script de build des images Docker pour K3s
# =============================================================================

set -e

echo "🐳 Build des images Docker pour EduMaster"
echo "=========================================="

# Registry (utiliser le registry local de K3s ou Docker Hub)
REGISTRY="localhost:5000"  # Ou votre registry

# 1. Build Course Service
echo "📦 Build course-service..."
cd ../services/course-service
docker build -t edumaster/course-service:latest .
docker tag edumaster/course-service:latest $REGISTRY/edumaster/course-service:latest
docker push $REGISTRY/edumaster/course-service:latest || echo "⚠️  Push ignoré (registry local)"

# 2. Build User Service
echo "📦 Build user-service..."
cd ../user-service
docker build -t edumaster/user-service:latest .
docker tag edumaster/user-service:latest $REGISTRY/edumaster/user-service:latest
docker push $REGISTRY/edumaster/user-service:latest || echo "⚠️  Push ignoré (registry local)"

# 3. Build Analytics Service
echo "📦 Build analytics-service..."
cd ../analytics-service
docker build -t edumaster/analytics-service:latest .
docker tag edumaster/analytics-service:latest $REGISTRY/edumaster/analytics-service:latest
docker push $REGISTRY/edumaster/analytics-service:latest || echo "⚠️  Push ignoré (registry local)"

# 4. Build AI Tutor Service
echo "📦 Build ai-tutor-service..."
cd ../ai-tutor-service
docker build -t edumaster/ai-tutor-service:latest .
docker tag edumaster/ai-tutor-service:latest $REGISTRY/edumaster/ai-tutor-service:latest
docker push $REGISTRY/edumaster/ai-tutor-service:latest || echo "⚠️  Push ignoré (registry local)"

# 5. Build Frontend
echo "📦 Build frontend..."
cd ../../frontend
docker build -t edumaster/frontend:latest .
docker tag edumaster/frontend:latest $REGISTRY/edumaster/frontend:latest
docker push $REGISTRY/edumaster/frontend:latest || echo "⚠️  Push ignoré (registry local)"

# 6. Build n8n
echo "📦 Build n8n..."
cd ../n8n
docker build -t edumaster/n8n:latest .
docker tag edumaster/n8n:latest $REGISTRY/edumaster/n8n:latest
docker push $REGISTRY/edumaster/n8n:latest || echo "⚠️  Push ignoré (registry local)"

cd ../k8s

echo ""
echo "✅ Build terminé !"
echo "=================="
echo ""
echo "Images créées:"
docker images | grep edumaster
