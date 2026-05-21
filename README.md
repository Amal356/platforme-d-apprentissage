# 🎓 EduMaster - Plateforme d'Apprentissage

**Version:** 1.0.0  
**Date:** 20 Mai 2026  
**Status:** ✅ Opérationnel (100%)

---

## 🚀 Démarrage Rapide

### Prérequis
- Docker Desktop installé et en cours d'exécution
- Ports disponibles : 80, 3000, 5432, 5680, 8001-8004, 9000-9001, 27017

### Lancer le projet
```bash
cd plateform-apprentissage
docker compose up -d
```

### Accéder à l'application
- **Site web** : http://localhost ou http://localhost:3000
- **Inscription** : http://localhost:3000/auth/register
- **Connexion** : http://localhost:3000/auth/login

---

## 🎨 Design & Branding

### Nom du site
**EduMaster** - Plateforme d'apprentissage moderne

### Thème de couleurs
- **Primaire** : Indigo (#6366f1)
- **Secondaire** : Purple (#a855f7)
- **Accent** : Emerald (#10b981)

### Logo
Icône de graduation avec gradient indigo-purple

---

## 📊 Architecture

### Services (11 conteneurs)

| Service | Port | Description | Status |
|---------|------|-------------|--------|
| **Frontend** | 3000 | Next.js 14.2.18 | ✅ |
| **Nginx Gateway** | 80 | Reverse proxy | ✅ |
| **Course Service** | 8001 | API FastAPI | ✅ |
| **User Service** | 8002 | API Node.js | ✅ |
| **Analytics Service** | 8003 | API FastAPI | ✅ |
| **AI Tutor Service** | 8004 | API FastAPI + Ollama | ✅ |
| **PostgreSQL** | 5432 | Base de données | ✅ |
| **MongoDB** | 27017 | Base de données | ✅ |
| **Redis** | 6379 | Cache | ✅ |
| **n8n** | 5680 | Automatisation | ✅ |
| **MinIO** | 9000-9001 | Stockage objet | ✅ |

---

## 🔐 Identifiants

### n8n Automation
- **URL** : http://localhost:5680
- **Utilisateur** : `admin`
- **Mot de passe** : `N8n@2026!Secure`

### MinIO Object Storage
- **Console** : http://localhost:9001
- **Utilisateur** : `admin`
- **Mot de passe** : `Admin@2026!Secure`

### Bases de données
- **PostgreSQL** : lms_user / lms_password
- **MongoDB** : Pas d'authentification
- **Redis** : Pas d'authentification

---

## 🧪 Tests

### Tester l'inscription
1. Aller sur http://localhost:3000/auth/register
2. Remplir le formulaire
3. Cliquer sur "Create Account"

### Tester l'API directement
```powershell
$body = @{
    name='Test User'
    email='test@example.com'
    password='Test123!'
    role='student'
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost/api/auth/register `
    -Method POST `
    -Body $body `
    -ContentType 'application/json'
```

### Vérifier les services
```bash
docker compose ps
```

---

## 📚 Documentation API

### Course Service
- **Swagger** : http://localhost:8001/docs
- **Endpoints** :
  - `GET /api/courses` - Liste des cours
  - `GET /api/courses/{id}` - Détail d'un cours
  - `POST /api/courses` - Créer un cours

### User Service
- **Base URL** : http://localhost:8002
- **Endpoints** :
  - `POST /api/auth/register` - Inscription
  - `POST /api/auth/login` - Connexion
  - `GET /api/users/me` - Profil utilisateur

### Analytics Service
- **Swagger** : http://localhost:8003/docs
- **Endpoints** :
  - `POST /api/analytics/events` - Enregistrer un événement
  - `GET /api/analytics/dashboard` - Tableau de bord

### AI Tutor Service
- **Swagger** : http://localhost:8004/docs
- **Endpoints** :
  - `POST /api/ai/chat` - Chat avec l'IA
  - `POST /api/ai/recommendations` - Recommandations
  - `POST /api/ai/quiz/generate` - Générer un quiz

---

## 🛠️ Commandes Utiles

### Démarrer tous les services
```bash
docker compose up -d
```

### Arrêter tous les services
```bash
docker compose down
```

### Reconstruire un service
```bash
docker compose up -d --build <service-name>
```

### Voir les logs
```bash
docker logs <container-name> -f
```

### Redémarrer un service
```bash
docker compose restart <service-name>
```

### Nettoyer complètement
```bash
docker compose down -v
docker compose up -d --build
```

---

## 🐛 Dépannage

### L'inscription ne fonctionne pas
1. Vider le cache du navigateur : `Ctrl + Shift + Delete`
2. Faire un Hard Refresh : `Ctrl + Shift + R`
3. Essayer en navigation privée : `Ctrl + Shift + N`
4. Vérifier les logs : `docker logs plateform-apprentissage-user-service-1`

### Un service ne démarre pas
```bash
docker compose ps
docker logs <container-name>
docker compose restart <service-name>
```

### Erreur de port déjà utilisé
```bash
# Trouver le processus qui utilise le port
netstat -ano | findstr :<port>
# Arrêter le processus
taskkill /PID <pid> /F
```

### Réinitialiser complètement
```bash
docker compose down -v
docker system prune -a
docker compose up -d --build
```

---

## 📁 Structure du Projet

```
plateform-apprentissage/
├── frontend/                 # Next.js frontend
│   ├── src/
│   │   ├── app/             # Pages et layouts
│   │   ├── components/      # Composants UI
│   │   └── lib/             # Utilitaires (API client)
│   └── Dockerfile
├── services/
│   ├── course-service/      # FastAPI - Gestion des cours
│   ├── user-service/        # Node.js - Authentification
│   ├── analytics-service/   # FastAPI - Analytics
│   └── ai-tutor-service/    # FastAPI - IA
├── nginx/
│   └── nginx.conf           # Configuration reverse proxy
├── db/
│   └── init/                # Scripts d'initialisation DB
├── n8n/                     # Workflows n8n
├── docker-compose.yml       # Configuration Docker
├── IDENTIFIANTS.md          # Identifiants de connexion
├── ETAT_PROJET.md          # État détaillé du projet
└── README.md               # Ce fichier
```

---

## 🔒 Sécurité

### ⚠️ IMPORTANT - Avant la production

1. **Changer tous les mots de passe**
   - n8n : `N8N_BASIC_AUTH_PASSWORD`
   - MinIO : `MINIO_ROOT_PASSWORD`
   - PostgreSQL : `POSTGRES_PASSWORD`
   - JWT : `JWT_SECRET`

2. **Activer HTTPS**
   - Configurer un certificat SSL
   - Modifier nginx.conf pour HTTPS

3. **Activer l'authentification**
   - MongoDB : Activer l'authentification
   - Redis : Configurer un mot de passe

4. **Configurer les CORS**
   - Limiter les origines autorisées
   - Configurer les headers de sécurité

5. **Variables d'environnement**
   - Utiliser des secrets Docker
   - Ne jamais commiter les fichiers .env

---

## 🎯 Fonctionnalités

### ✅ Implémentées
- ✅ Inscription et connexion utilisateur
- ✅ Gestion des cours et leçons
- ✅ Système d'inscription aux cours
- ✅ Suivi de progression
- ✅ Système de notation et avis
- ✅ Tuteur IA avec Ollama
- ✅ Recommandations personnalisées
- ✅ Génération de quiz par IA
- ✅ Analytics et tracking
- ✅ Dashboard administrateur
- ✅ Interface moderne et responsive

### 🚧 À venir
- 🚧 Système de paiement
- 🚧 Certificats de complétion
- 🚧 Forum de discussion
- 🚧 Messagerie instantanée
- 🚧 Notifications push
- 🚧 Application mobile

---

## 📈 Statistiques

- **Lignes de code** : ~15,000
- **Services** : 11
- **APIs** : 4
- **Pages frontend** : 10+
- **Composants UI** : 20+
- **Cours de démo** : 10
- **Leçons de démo** : 40+

---

## 🤝 Contribution

Ce projet a été développé dans le cadre du **Master DevOps & Cloud - M1**.

### Technologies utilisées
- **Frontend** : Next.js 14, React 18, TypeScript, Tailwind CSS
- **Backend** : FastAPI (Python), Express (Node.js)
- **Bases de données** : PostgreSQL, MongoDB, Redis
- **IA** : Ollama (llama3.2)
- **Automatisation** : n8n
- **Conteneurisation** : Docker, Docker Compose
- **Reverse Proxy** : Nginx

---

## 📞 Support

Pour toute question ou problème :
1. Consulter `ETAT_PROJET.md` pour l'état détaillé
2. Consulter `IDENTIFIANTS.md` pour les accès
3. Vérifier les logs : `docker logs <container-name>`
4. Ouvrir la console du navigateur (F12) pour les erreurs frontend

---

## 🎉 Félicitations !

Votre plateforme **EduMaster** est maintenant opérationnelle ! 🚀

**Prochaines étapes recommandées :**
1. Créer un compte utilisateur
2. Explorer les cours disponibles
3. Tester le tuteur IA
4. Consulter le dashboard analytics
5. Personnaliser le contenu

---

**Développé avec ❤️ par l'équipe EduMaster**  
**© 2026 - Tous droits réservés**
