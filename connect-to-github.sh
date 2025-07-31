#!/bin/bash

echo "🔗 Conectando MentorAI Frontend con GitHub..."

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo "❌ Error: No estás en el directorio del frontend"
    exit 1
fi

echo "📋 Instrucciones:"
echo "1. Ve a https://github.com/new"
echo "2. Crea un repositorio llamado 'mentorai-frontend'"
echo "3. NO inicialices con README (ya tenemos uno)"
echo "4. Copia la URL del repositorio"
echo ""
echo "Una vez creado, ejecuta:"
echo "git remote add origin https://github.com/TU_USUARIO/mentorai-frontend.git"
echo "git branch -M main"
echo "git push -u origin main"
echo ""
echo "Reemplaza TU_USUARIO con tu nombre de usuario de GitHub" 