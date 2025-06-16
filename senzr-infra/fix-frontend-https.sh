#!/bin/bash

set -e
echo "🔧 Fixing Frontend HTTPS Configuration..."

# Step 1: Update .env to use HTTPS
cat > .env << 'EOF2'
VITE_API_URL=https://d3hubh9hy19nx8.cloudfront.net/api
VITE_DIRECTUS_URL=https://d3hubh9hy19nx8.cloudfront.net/api
VITE_API_TOKEN=4rsbNcG55OJ0qDiFrYWHWvkzaf6sFd3w
VITE_ADMIN_EMAIL=admin@senzr.com
VITE_ADMIN_PASSWORD=DirectusAdmin123!
DIRECTUS_AUTO_REDIRECT=false
EOF2

echo "✅ Updated .env file to use HTTPS"

# Step 2: Update deployment to use HTTPS and add API proxy
cat > frontend-complete.yaml << 'EOF2'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-app
  labels:
    app: frontend-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend-app
  template:
    metadata:
      labels:
        app: frontend-app
    spec:
      containers:
      - name: frontend
        image: nginx:alpine
        ports:
        - containerPort: 80
        env:
        - name: VITE_API_URL
          value: "https://d3hubh9hy19nx8.cloudfront.net/api"
        - name: VITE_DIRECTUS_URL  
          value: "https://d3hubh9hy19nx8.cloudfront.net/api"
        volumeMounts:
        - name: nginx-config
          mountPath: /etc/nginx/conf.d/default.conf
          subPath: default.conf
        - name: frontend-html
          mountPath: /usr/share/nginx/html
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
      volumes:
      - name: nginx-config
        configMap:
          name: frontend-nginx-config
      - name: frontend-html
        configMap:
          name: frontend-html-files

---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
spec:
  type: LoadBalancer
  selector:
    app: frontend-app
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: frontend-nginx-config
data:
  default.conf: |
    server {
        listen 80;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;
        
        # Handle Vue.js router (SPA)
        location / {
            try_files $uri $uri/ /index.html;
            add_header Cache-Control "no-cache, no-store, must-revalidate";
        }
        
        # Proxy API calls to Kong (fixes HTTPS Mixed Content)
        location /api/ {
            proxy_pass http://ad5b1eb3b1fff4345bd4d4be7065213f-272763669.ap-south-1.elb.amazonaws.com:8000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            # CORS headers
            add_header Access-Control-Allow-Origin "*" always;
            add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS" always;
            add_header Access-Control-Allow-Headers "Accept, Authorization, Content-Type, X-Requested-With" always;
            
            # Handle preflight requests
            if ($request_method = 'OPTIONS') {
                add_header Access-Control-Allow-Origin "*";
                add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS";
                add_header Access-Control-Allow-Headers "Accept, Authorization, Content-Type, X-Requested-With";
                add_header Content-Length 0;
                add_header Content-Type text/plain;
                return 204;
            }
        }
        
        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
EOF2

echo "✅ Updated deployment with HTTPS URLs and API proxy"

# Step 3: Rebuild frontend
echo "🔨 Rebuilding frontend with HTTPS..."
npm run build

# Step 4: Update ConfigMap
echo "📦 Updating ConfigMap..."
kubectl delete configmap frontend-html-files --ignore-not-found=true
kubectl create configmap frontend-html-files --from-file=dist/

# Step 5: Apply changes
echo "🚀 Applying changes..."
kubectl apply -f frontend-complete.yaml

# Step 6: Restart deployment
echo "♻️ Restarting deployment..."
kubectl rollout restart deployment/frontend-app
kubectl rollout status deployment/frontend-app --timeout=300s

echo ""
echo "✅ HTTPS fix complete!"
echo "🌐 Test your app at: https://d3hubh9hy19nx8.cloudfront.net/login"
echo "📧 Email: admin@senzr.com"
echo "🔑 Password: DirectusAdmin123!"
