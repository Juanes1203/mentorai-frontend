# 🚀 Guía Completa: Repositorios GitHub Separados

Esta guía te ayudará a crear y configurar los repositorios de GitHub separados para MentorAI.

## 📋 Resumen

- **Backend**: `mentorai-backend` - API Express/Node.js
- **Frontend**: `mentorai-frontend` - Aplicación React/TypeScript

## 🔧 Paso 1: Crear Repositorios en GitHub

### 1.1 Crear Repositorio Backend

1. Ve a [GitHub.com](https://github.com)
2. Haz clic en "New" o "New repository"
3. Configura:
   - **Repository name**: `mentorai-backend`
   - **Description**: `Backend API for MentorAI Virtual Teacher application`
   - **Visibility**: Public
   - **NO inicializar** con README (ya tenemos uno)
4. Haz clic en "Create repository"

### 1.2 Crear Repositorio Frontend

1. Repite el proceso:
   - **Repository name**: `mentorai-frontend`
   - **Description**: `Frontend React application for MentorAI Virtual Teacher`
   - **Visibility**: Public
   - **NO inicializar** con README

## 🔗 Paso 2: Conectar Repositorios Locales

### 2.1 Conectar Backend

```bash
cd ../mentorai-backend
git remote add origin https://github.com/TU_USUARIO/mentorai-backend.git
git branch -M main
git push -u origin main
```

### 2.2 Conectar Frontend

```bash
cd ../mentorai-frontend
git remote add origin https://github.com/TU_USUARIO/mentorai-frontend.git
git branch -M main
git push -u origin main
```

**Reemplaza `TU_USUARIO` con tu nombre de usuario de GitHub**

## 🚀 Paso 3: Configuración de Desarrollo

### 3.1 Configurar Backend

```bash
cd ../mentorai-backend
./setup-complete.sh
```

### 3.2 Configurar Frontend

```bash
cd ../mentorai-frontend
./setup-complete.sh
```

## 🔧 Paso 4: Variables de Entorno

### Backend (.env)
```env
PORT=5001
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=tu_password_aqui
DB_NAME=mentorai_db
JWT_SECRET=tu_jwt_secret_super_seguro
STRAICO_API_KEY=tu_straico_api_key
ELEVENLABS_API_KEY=tu_elevenlabs_api_key
```

### Frontend (.env)
```env
VITE_API_BASE_URL=http://localhost:5001/api
VITE_STRAICO_API_KEY=tu_straico_api_key
VITE_ELEVENLABS_API_KEY=tu_elevenlabs_api_key
```

## 🗄️ Paso 5: Configurar Base de Datos

```bash
# Conectar a MySQL
mysql -u root -p

# Crear base de datos
CREATE DATABASE mentorai_db;

# Ejecutar schema
mysql -u root -p mentorai_db < database/schema.sql
```

## 🏃‍♂️ Paso 6: Iniciar Desarrollo

### Iniciar Backend
```bash
cd ../mentorai-backend
npm run dev
```

### Iniciar Frontend
```bash
cd ../mentorai-frontend
npm run dev
```

## 🌐 URLs de Desarrollo

- **Frontend**: http://localhost:8080
- **Backend API**: http://localhost:5001
- **Health Check**: http://localhost:5001/api/health

## 🔍 Verificación

### 1. Verificar Backend
```bash
curl http://localhost:5001/api/health
```

Respuesta esperada:
```json
{
  "status": "ok",
  "database": "connected",
  "timestamp": "2025-01-XX..."
}
```

### 2. Verificar Frontend
- Abrir http://localhost:8080
- Verificar que no hay errores de CORS
- Probar funcionalidades principales

## 📁 Estructura Final

```
Desktop/
├── mentorai-virtual-teacher/     # Repo original (monorepo)
├── mentorai-backend/            # Repo separado - Backend
└── mentorai-frontend/           # Repo separado - Frontend
```

## 🔄 Flujo de Desarrollo

### Trabajar en Backend
```bash
cd ../mentorai-backend
# Hacer cambios
git add .
git commit -m "Descripción de cambios"
git push origin main
```

### Trabajar en Frontend
```bash
cd ../mentorai-frontend
# Hacer cambios
git add .
git commit -m "Descripción de cambios"
git push origin main
```

## 🚨 Troubleshooting

### Error de CORS
- Verificar que el backend está corriendo en puerto 5001
- Revisar configuración CORS en `backend/src/index.ts`

### Error de Base de Datos
- Verificar que MySQL está corriendo
- Comprobar credenciales en `.env`

### Error de Variables de Entorno
- Verificar que los archivos `.env` están configurados
- Comprobar que las API keys son válidas

## 📝 Notas Importantes

- **Independencia**: Cada repositorio evoluciona por separado
- **Conexión**: El frontend se conecta al backend via proxy en desarrollo
- **Deployment**: Cada repositorio se despliega independientemente
- **Testing**: Cada repositorio tiene su propio testing

## 🎯 Próximos Pasos

1. **CI/CD**: Configurar GitHub Actions para cada repositorio
2. **Testing**: Implementar tests unitarios y de integración
3. **Documentación**: API documentation con Swagger
4. **Deployment**: Configurar deployment automático 