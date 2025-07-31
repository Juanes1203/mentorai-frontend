#!/bin/bash

echo "🚀 Configurando MentorAI Frontend..."

# Instalar dependencias
echo "📦 Instalando dependencias..."
npm install

# Crear archivo .env si no existe
if [ ! -f .env ]; then
    echo "🔧 Creando archivo .env..."
    cp env.example .env
    echo "✅ Archivo .env creado. Por favor, configura tus variables de entorno."
fi

echo "✅ Configuración completada!"
echo ""
echo "📋 Para iniciar el desarrollo:"
echo "   npm run dev"
echo ""
echo "🌐 La aplicación estará disponible en: http://localhost:8080"
echo ""
echo "⚠️  Asegúrate de que el backend esté corriendo en http://localhost:5001" 