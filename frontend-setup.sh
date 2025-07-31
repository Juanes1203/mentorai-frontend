#!/bin/bash

# Frontend Setup Script for MentorAI Application
# This script installs all necessary dependencies for the React frontend

set -e  # Exit on any error

echo "🎨 Starting MentorAI Frontend Setup..."
echo "======================================"

# Configuration
FRONTEND_DIR="/var/www/mentorai/frontend"
REPO_URL="https://github.com/Juanes1203/mentorai-frontend.git"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root. Please run as a regular user with sudo privileges."
   exit 1
fi

# Check if Node.js is installed
print_status "Checking Node.js installation..."
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please run the ubuntu-setup.sh script first."
    exit 1
fi

NODE_VERSION=$(node --version)
print_success "Node.js version: $NODE_VERSION"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please run the ubuntu-setup.sh script first."
    exit 1
fi

NPM_VERSION=$(npm --version)
print_success "npm version: $NPM_VERSION"

# Create frontend directory
print_status "Creating frontend directory..."
sudo mkdir -p $FRONTEND_DIR
sudo chown $USER:$USER $FRONTEND_DIR

# Clone repository
print_status "Cloning frontend repository..."
if [ -d "$FRONTEND_DIR/.git" ]; then
    print_warning "Repository already exists. Pulling latest changes..."
    cd $FRONTEND_DIR
    git pull origin main
else
    cd $FRONTEND_DIR
    git clone $REPO_URL .
fi

# Install dependencies
print_status "Installing npm dependencies..."
npm install

# Create production environment file
print_status "Creating production environment file..."
cat > $FRONTEND_DIR/.env << 'EOF'
# Production Environment Variables
VITE_API_BASE_URL=https://your-domain.com/api

# API Keys (Update these with your actual keys)
VITE_ELEVENLABS_API_KEY=your_elevenlabs_key_here
VITE_STRAICO_API_KEY=your_straico_key_here

# Development Settings
VITE_DEV_MODE=false
VITE_DEBUG_ENABLED=false
EOF

print_warning "Please update the .env file with your actual API keys and domain."

# Build the application
print_status "Building the application for production..."
npm run build

# Verify build
if [ -d "$FRONTEND_DIR/dist" ]; then
    print_success "Build completed successfully!"
    print_status "Build files created in: $FRONTEND_DIR/dist"
else
    print_error "Build failed! Please check the error messages above."
    exit 1
fi

# Create nginx configuration for frontend
print_status "Creating nginx configuration..."
sudo tee /etc/nginx/sites-available/mentorai-frontend << EOF
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # Frontend files
    location / {
        root $FRONTEND_DIR/dist;
        try_files \$uri \$uri/ /index.html;
        
        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
        
        # No cache for HTML files
        location ~* \.html$ {
            add_header Cache-Control "no-cache, no-store, must-revalidate";
            add_header Pragma "no-cache";
            add_header Expires "0";
        }
    }

    # Backend API proxy
    location /api {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        
        # Timeout settings
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;
}
EOF

# Enable the site
print_status "Enabling nginx site..."
sudo ln -sf /etc/nginx/sites-available/mentorai-frontend /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test nginx configuration
print_status "Testing nginx configuration..."
if sudo nginx -t; then
    print_success "Nginx configuration is valid!"
else
    print_error "Nginx configuration test failed!"
    exit 1
fi

# Restart nginx
print_status "Restarting nginx..."
sudo systemctl restart nginx

# Create PM2 ecosystem file for frontend (optional)
print_status "Creating PM2 configuration for frontend..."
cat > $FRONTEND_DIR/ecosystem.config.js << EOF
module.exports = {
  apps: [
    {
      name: 'mentorai-frontend',
      cwd: '$FRONTEND_DIR',
      script: 'npm',
      args: 'run preview',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '512M',
      env: {
        NODE_ENV: 'production',
        PORT: 8080
      },
      error_file: '/var/log/mentorai/frontend-error.log',
      out_file: '/var/log/mentorai/frontend-out.log',
      log_file: '/var/log/mentorai/frontend-combined.log',
      time: true
    }
  ]
};
EOF

# Create log directory
sudo mkdir -p /var/log/mentorai
sudo chown $USER:$USER /var/log/mentorai

# Create update script
print_status "Creating update script..."
cat > $FRONTEND_DIR/update.sh << 'EOF'
#!/bin/bash

echo "🔄 Updating MentorAI Frontend..."

# Pull latest changes
git pull origin main

# Install dependencies
npm install

# Build for production
npm run build

echo "✅ Frontend updated successfully!"
echo "🔄 Restarting nginx..."
sudo systemctl restart nginx

echo "✅ Update completed!"
EOF

chmod +x $FRONTEND_DIR/update.sh

# Create health check script
print_status "Creating health check script..."
cat > $FRONTEND_DIR/health-check.sh << 'EOF'
#!/bin/bash

echo "🏥 Checking MentorAI Frontend Health..."

# Check if nginx is running
if sudo systemctl is-active --quiet nginx; then
    echo "✅ Nginx is running"
else
    echo "❌ Nginx is not running"
fi

# Check if build files exist
if [ -d "dist" ] && [ "$(ls -A dist)" ]; then
    echo "✅ Build files exist"
else
    echo "❌ Build files missing"
fi

# Check if .env file exists
if [ -f ".env" ]; then
    echo "✅ Environment file exists"
else
    echo "❌ Environment file missing"
fi

# Check disk space
DISK_USAGE=$(df -h . | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 90 ]; then
    echo "✅ Disk space OK ($DISK_USAGE%)"
else
    echo "⚠️  Disk space low ($DISK_USAGE%)"
fi

echo "🏥 Health check completed!"
EOF

chmod +x $FRONTEND_DIR/health-check.sh

print_success "Frontend setup completed successfully!"
echo ""
echo "🎨 MentorAI Frontend Setup Summary"
echo "=================================="
echo ""
echo "📁 Installation directory: $FRONTEND_DIR"
echo "🌐 Nginx configuration: /etc/nginx/sites-available/mentorai-frontend"
echo "📝 Environment file: $FRONTEND_DIR/.env"
echo "📊 Log directory: /var/log/mentorai"
echo ""
echo "🔧 Configuration needed:"
echo "   1. Update domain in nginx config: /etc/nginx/sites-available/mentorai-frontend"
echo "   2. Update API keys in: $FRONTEND_DIR/.env"
echo "   3. Configure SSL certificate (recommended)"
echo ""
echo "📋 Useful commands:"
echo "   sudo systemctl status nginx          # Check nginx status"
echo "   sudo nginx -t                        # Test nginx config"
echo "   cd $FRONTEND_DIR && ./update.sh     # Update frontend"
echo "   cd $FRONTEND_DIR && ./health-check.sh # Health check"
echo "   sudo tail -f /var/log/nginx/error.log # View nginx errors"
echo ""
echo "🌐 Access your application:"
echo "   Frontend: http://your-domain.com"
echo "   Backend API: http://your-domain.com/api"
echo ""
print_warning "Remember to replace 'your-domain.com' with your actual domain!"
echo "" 