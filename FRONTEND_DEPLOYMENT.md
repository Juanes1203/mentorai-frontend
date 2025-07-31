# 🎨 MentorAI Frontend Deployment Guide

This guide will help you deploy the MentorAI React frontend on Ubuntu.

## 📋 Prerequisites

- Ubuntu 20.04 LTS or later
- Node.js 20.x (installed via ubuntu-setup.sh)
- nginx web server
- Git access to the repository

## 🛠️ Frontend Dependencies

### Core Dependencies
- **React 18.3.1** - UI framework
- **Vite 5.4.1** - Build tool and dev server
- **TypeScript 5.5.3** - Type checking
- **Tailwind CSS 3.4.11** - CSS framework

### UI Components
- **Radix UI** - Accessible UI primitives
- **Lucide React** - Icons
- **React Hook Form** - Form handling
- **Zod** - Schema validation

### Additional Libraries
- **Axios** - HTTP client
- **React Router DOM** - Routing
- **React Query** - Data fetching
- **Recharts** - Charts and graphs
- **html2canvas & jsPDF** - PDF generation

## 🚀 Quick Setup

### 1. Run the Frontend Setup Script

```bash
# Download and run the frontend setup script
wget https://raw.githubusercontent.com/Juanes1203/mentorai-frontend/main/frontend-setup.sh
chmod +x frontend-setup.sh
./frontend-setup.sh
```

## 📦 Manual Installation

### 1. Install Node.js Dependencies

```bash
# Install Node.js 20.x (if not already installed)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verify installation
node --version
npm --version
```

### 2. Install nginx

```bash
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 3. Clone and Setup Frontend

```bash
# Create application directory
sudo mkdir -p /var/www/mentorai
sudo chown $USER:$USER /var/www/mentorai
cd /var/www/mentorai

# Clone frontend repository
git clone https://github.com/Juanes1203/mentorai-frontend.git frontend
cd frontend

# Install dependencies
npm install
```

### 4. Configure Environment

Create `.env` file:

```bash
cat > .env << 'EOF'
# Production Environment Variables
VITE_API_BASE_URL=https://your-domain.com/api

# API Keys (Update these with your actual keys)
VITE_ELEVENLABS_API_KEY=your_elevenlabs_key_here
VITE_STRAICO_API_KEY=your_straico_key_here

# Development Settings
VITE_DEV_MODE=false
VITE_DEBUG_ENABLED=false
EOF
```

### 5. Build Application

```bash
# Build for production
npm run build

# Verify build
ls -la dist/
```

### 6. Configure nginx

Create nginx configuration:

```bash
sudo tee /etc/nginx/sites-available/mentorai-frontend << 'EOF'
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
        root /var/www/mentorai/frontend/dist;
        try_files $uri $uri/ /index.html;
        
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
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
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
```

Enable the site:

```bash
sudo ln -sf /etc/nginx/sites-available/mentorai-frontend /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
```

## 🔧 Configuration

### Environment Variables

Update `/var/www/mentorai/frontend/.env`:

```env
# Production Environment Variables
VITE_API_BASE_URL=https://your-domain.com/api

# API Keys (Update these with your actual keys)
VITE_ELEVENLABS_API_KEY=your_elevenlabs_key_here
VITE_STRAICO_API_KEY=your_straico_key_here

# Development Settings
VITE_DEV_MODE=false
VITE_DEBUG_ENABLED=false
```

### nginx Configuration

Update `/etc/nginx/sites-available/mentorai-frontend`:

1. Replace `your-domain.com` with your actual domain
2. Update the `root` path if needed
3. Configure SSL certificate (recommended)

## 📊 Management Commands

### Build Commands
```bash
cd /var/www/mentorai/frontend

# Development
npm run dev

# Production build
npm run build

# Preview production build
npm run preview

# Lint code
npm run lint
```

### nginx Commands
```bash
# Test configuration
sudo nginx -t

# Restart nginx
sudo systemctl restart nginx

# Check status
sudo systemctl status nginx

# View logs
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

### Update Scripts

The setup creates two useful scripts:

```bash
cd /var/www/mentorai/frontend

# Update frontend
./update.sh

# Health check
./health-check.sh
```

## 🔒 SSL Configuration

### Install Certbot

```bash
sudo apt install -y certbot python3-certbot-nginx
```

### Get SSL Certificate

```bash
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

## 🔧 Troubleshooting

### Common Issues

1. **Build fails:**
   ```bash
   # Check Node.js version
   node --version
   
   # Clear npm cache
   npm cache clean --force
   
   # Reinstall dependencies
   rm -rf node_modules package-lock.json
   npm install
   ```

2. **nginx configuration error:**
   ```bash
   # Test configuration
   sudo nginx -t
   
   # Check syntax
   sudo nginx -T
   ```

3. **Frontend not loading:**
   ```bash
   # Check if build files exist
   ls -la /var/www/mentorai/frontend/dist/
   
   # Check nginx configuration
   sudo nginx -t
   
   # Check nginx logs
   sudo tail -f /var/log/nginx/error.log
   ```

4. **API calls failing:**
   ```bash
   # Check if backend is running
   curl http://localhost:3000/api/health
   
   # Check proxy configuration
   curl http://your-domain.com/api/health
   ```

### Debug Commands

```bash
# Check frontend build
cd /var/www/mentorai/frontend
npm run build

# Check nginx configuration
sudo nginx -t

# Check nginx status
sudo systemctl status nginx

# Check disk space
df -h

# Check memory usage
free -h

# Check running processes
ps aux | grep nginx
ps aux | grep node
```

## 📈 Performance Optimization

### nginx Optimizations

1. **Enable gzip compression** (already configured)
2. **Add caching headers** (already configured)
3. **Optimize static file serving**

### Build Optimizations

1. **Enable production mode:**
   ```bash
   NODE_ENV=production npm run build
   ```

2. **Analyze bundle size:**
   ```bash
   npm install -g vite-bundle-analyzer
   vite-bundle-analyzer dist
   ```

## 🔄 Updates

### Manual Update

```bash
cd /var/www/mentorai/frontend

# Pull latest changes
git pull origin main

# Install dependencies
npm install

# Build for production
npm run build

# Restart nginx
sudo systemctl restart nginx
```

### Using Update Script

```bash
cd /var/www/mentorai/frontend
./update.sh
```

## 📊 Monitoring

### Health Check

```bash
cd /var/www/mentorai/frontend
./health-check.sh
```

### Log Monitoring

```bash
# nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Application logs (if using PM2)
pm2 logs mentorai-frontend
```

## 🚀 Deployment Checklist

- [ ] Node.js 20.x installed
- [ ] nginx installed and configured
- [ ] Repository cloned
- [ ] Dependencies installed
- [ ] Environment variables configured
- [ ] Application built successfully
- [ ] nginx configuration tested
- [ ] SSL certificate installed (recommended)
- [ ] Domain DNS configured
- [ ] Firewall rules configured
- [ ] Health check passed

## 📞 Support

If you encounter issues:

1. Check the logs using the commands above
2. Verify all dependencies are installed correctly
3. Ensure nginx configuration is valid
4. Test the build process locally
5. Verify environment variables are set correctly

For additional help, check the GitHub repository:
- Frontend: https://github.com/Juanes1203/mentorai-frontend 