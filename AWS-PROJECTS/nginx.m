server {
    listen 80;
    server_name example.com;  # replace with your domain
    root /var/www/html;       # replace with your project root

    # ===============================
    # Security
    # ===============================
    server_tokens off;            # hide Nginx version
    client_max_body_size 20M;     # limit upload size
    autoindex off;                # disable directory listing

    # Block access to hidden files (.env, .git, .htaccess, etc.)
    location ~ /\.(?!well-known).* {
        deny all;
        access_log off;
        log_not_found off;
    }

    # Block access to sensitive extensions
    location ~* \.(bak|conf|sql|ini|log|sh)$ {
        deny all;
    }

    # ===============================
    # Static files & performance
    # ===============================
    # Serve static files efficiently with caching
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2|ttf|svg|eot)$ {
        expires 30d;
        add_header Cache-Control "public";
    }

    # Gzip compression for text-based assets
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
    gzip_min_length 256;
    gzip_comp_level 5;

    # ===============================
    # App routing
    # ===============================
    location / {
        try_files $uri $uri/ /index.html;  # for SPA or adjust for backend
    }

    # ===============================
    # Optional security headers
    # ===============================
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self';" always;

    # ===============================
    # Logging
    # ===============================
    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log warn;
}
