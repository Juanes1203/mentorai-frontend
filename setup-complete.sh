#!/bin/bash

echo "🚀 Configuración Completa - MentorAI Frontend"
echo "=============================================="

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo "❌ Error: No estás en el directorio del frontend"
    exit 1
fi

echo "📦 Instalando dependencias..."
npm install

echo "🔧 Configurando variables de entorno..."
if [ ! -f ".env" ]; then
    cp env.example .env
    echo "✅ Archivo .env creado"
else
    echo "✅ Archivo .env ya existe"
fi

echo ""
echo "🌐 URLs de Desarrollo:"
echo "   Frontend: http://localhost:8080"
echo "   Backend:  http://localhost:5001"
echo ""

echo "📋 Próximos pasos:"
echo "1. Configura las variables en .env"
echo "2. Asegúrate de que el backend esté corriendo"
echo "3. Ejecuta: npm run dev"
echo ""

echo "🔗 Para conectar con GitHub:"
echo "   ./connect-to-github.sh"
echo ""

echo "✅ Configuración completada!" 