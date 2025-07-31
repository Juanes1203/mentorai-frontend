# 🔄 Guía de Separación de Repositorios

Esta guía documenta el proceso de separación del monorepo `mentorai-virtual-teacher` en dos repositorios independientes.

## 📋 Resumen de Cambios

### Repositorios Creados
1. **`mentorai-frontend`** - Aplicación React/TypeScript
2. **`mentorai-backend`** - API Express/Node.js

### Repositorio Original
- **`mentorai-virtual-teacher`** - Monorepo original (mantenido como referencia)

## 🚀 Proceso de Separación

### 1. Estructura de Archivos Copiados

#### Frontend (`mentorai-frontend/`)
```
├── src/                    # Código React/TypeScript
├── public/                 # Archivos públicos
├── package.json            # Dependencias frontend
├── vite.config.ts          # Configuración Vite
├── tailwind.config.ts      # Configuración Tailwind
├── tsconfig.json           # Configuración TypeScript
├── README.md              # Documentación
├── dev-setup.sh           # Script de configuración
├── env.example            # Variables de entorno
└── CONNECTION_GUIDE.md    # Guía de conexión
```

#### Backend (`mentorai-backend/`)
```
├── src/                    # Código Express/Node.js
├── database/               # Scripts de base de datos
├── package.json            # Dependencias backend
├── tsconfig.json           # Configuración TypeScript
├── README.md              # Documentación
├── dev-setup.sh           # Script de configuración
├── env.example            # Variables de entorno
└── dist/                  # Código compilado
```

### 2. Configuraciones Modificadas

#### Frontend
- **package.json**: Nombre cambiado a `mentorai-frontend`
- **vite.config.ts**: Base path actualizado a `/mentorai-frontend/`
- **Proxy**: Configurado para redirigir `/api` a `http://localhost:5001`

#### Backend
- **package.json**: Keywords actualizadas
- **CORS**: Ya configurado para aceptar conexiones del frontend
- **Puerto**: Configurado en 5001

### 3. Variables de Entorno

#### Frontend (.env)
```env
VITE_API_BASE_URL=http://localhost:5001/api
VITE_STRAICO_API_KEY=your_straico_api_key
VITE_ELEVENLABS_API_KEY=your_elevenlabs_api_key
```

#### Backend (.env)
```env
PORT=5001
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=mentorai_db
JWT_SECRET=your_jwt_secret
STRAICO_API_KEY=your_straico_api_key
ELEVENLABS_API_KEY=your_elevenlabs_api_key
```

## 🔧 Configuración de Desarrollo

### Iniciar Backend
```bash
cd mentorai-backend
./dev-setup.sh
npm run dev
```

### Iniciar Frontend
```bash
cd mentorai-frontend
./dev-setup.sh
npm run dev
```

## 🌐 URLs de Desarrollo

- **Frontend**: http://localhost:8080
- **Backend API**: http://localhost:5001
- **Health Check**: http://localhost:5001/api/health

## 📁 Estructura Final

```
Desktop/
├── mentorai-virtual-teacher/     # Repo original (monorepo)
│   ├── src/                     # Frontend
│   ├── backend/                 # Backend
│   └── ...
├── mentorai-frontend/           # Repo separado
│   ├── src/
│   ├── public/
│   └── ...
└── mentorai-backend/            # Repo separado
    ├── src/
    ├── database/
    └── ...
```

## 🔄 Ventajas de la Separación

### Independencia
- Cada repositorio puede evolucionar independientemente
- Diferentes equipos pueden trabajar en paralelo
- Deployment independiente

### Mantenimiento
- Código más organizado y específico
- Dependencias separadas
- Testing independiente

### Escalabilidad
- Fácil agregar nuevos servicios
- Microservicios en el futuro
- Diferentes tecnologías por servicio

## 🛠️ Próximos Pasos

### 1. Crear Repositorios Git
```bash
# Frontend
cd mentorai-frontend
git init
git add .
git commit -m "Initial commit: MentorAI Frontend"

# Backend
cd ../mentorai-backend
git init
git add .
git commit -m "Initial commit: MentorAI Backend"
```

### 2. Configurar CI/CD
- GitHub Actions para cada repositorio
- Testing automatizado
- Deployment independiente

### 3. Documentación
- API Documentation (Swagger)
- Component Library
- Deployment guides

## 📝 Notas Importantes

- **Compatibilidad**: Ambos repositorios mantienen la misma funcionalidad
- **Conexión**: El frontend se conecta al backend via proxy en desarrollo
- **Variables**: Cada repositorio tiene sus propias variables de entorno
- **Dependencias**: No hay dependencias cruzadas entre repositorios

## 🔍 Verificación

### 1. Backend
```bash
curl http://localhost:5001/api/health
```

### 2. Frontend
- Abrir http://localhost:8080
- Verificar que no hay errores de CORS
- Probar funcionalidades principales

### 3. Conexión
- Crear una clase desde el frontend
- Verificar que se guarda en la base de datos
- Probar análisis de transcripción

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