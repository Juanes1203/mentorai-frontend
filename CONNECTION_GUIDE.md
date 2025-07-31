# 🔗 Guía de Conexión Frontend-Backend

Esta guía explica cómo conectar el frontend con el backend en desarrollo local.

## 📋 Prerrequisitos

1. **Backend corriendo** en `http://localhost:5001`
2. **MySQL** instalado y configurado
3. **Variables de entorno** configuradas correctamente

## 🚀 Inicio Rápido

### 1. Iniciar Backend
```bash
cd ../mentorai-backend
./dev-setup.sh
npm run dev
```

### 2. Iniciar Frontend
```bash
cd ../mentorai-frontend
./dev-setup.sh
npm run dev
```

## 🔧 Configuración

### Variables de Entorno Frontend (.env)
```env
VITE_API_BASE_URL=http://localhost:5001/api
VITE_STRAICO_API_KEY=your_straico_api_key
VITE_ELEVENLABS_API_KEY=your_elevenlabs_api_key
```

### Variables de Entorno Backend (.env)
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

## 🌐 URLs de Desarrollo

- **Frontend**: http://localhost:8080
- **Backend API**: http://localhost:5001
- **Health Check**: http://localhost:5001/api/health

## 🔍 Verificación de Conexión

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
Abrir http://localhost:8080 en el navegador y verificar que:
- La aplicación carga correctamente
- No hay errores de CORS en la consola
- Las llamadas a la API funcionan

## 🛠️ Troubleshooting

### Error de CORS
Si ves errores de CORS, verifica:
1. El backend está corriendo en puerto 5001
2. El frontend está corriendo en puerto 8080
3. La configuración CORS en `backend/src/index.ts`

### Error de Base de Datos
Si hay errores de BD:
1. MySQL está corriendo
2. La base de datos `mentorai_db` existe
3. Las credenciales en `.env` son correctas

### Error de Variables de Entorno
Si las APIs externas no funcionan:
1. Verifica que las API keys estén configuradas
2. Revisa la consola del navegador para errores
3. Verifica los logs del backend

## 📁 Estructura de Repositorios

```
mentorai-virtual-teacher/          # Repo original (monorepo)
├── src/                          # Frontend
├── backend/                      # Backend
└── ...

mentorai-frontend/                # Repo separado
├── src/
├── public/
├── package.json
└── ...

mentorai-backend/                 # Repo separado
├── src/
├── database/
├── package.json
└── ...
```

## 🔄 Flujo de Desarrollo

1. **Desarrollo Backend**: Trabaja en `mentorai-backend/`
2. **Desarrollo Frontend**: Trabaja en `mentorai-frontend/`
3. **Testing**: Ambos repositorios funcionan independientemente
4. **Deployment**: Cada repositorio se despliega por separado

## 📝 Notas Importantes

- El frontend usa un proxy en Vite para redirigir `/api` al backend
- El backend tiene CORS configurado para aceptar conexiones del frontend
- Ambos repositorios mantienen su funcionalidad independiente
- Los cambios en un repositorio no afectan al otro 