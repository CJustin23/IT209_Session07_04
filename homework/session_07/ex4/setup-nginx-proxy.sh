#!/usr/bin/env bash
set -euo pipefail

sudo mkdir -p /var/www/html
sudo tee /var/www/html/index.html >/dev/null <<'HTML'
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Spring Boot Proxy Demo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 50px;
            background-color: #f4f6f9;
            color: #1f2937;
        }
        .card {
            background: white;
            max-width: 600px;
            margin: auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        h1 {
            color: #0f172a;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>Thông tin học viên</h1>
        <p><strong>Họ tên:</strong> Nguyễn Văn A</p>
        <p><strong>Mã lớp:</strong> IT209</p>
        <p>Đây là trang tĩnh được phục vụ bởi Nginx qua Reverse Proxy.</p>
    </div>
</body>
</html>
HTML

sudo tee /etc/nginx/sites-available/spring-proxy.conf >/dev/null <<'CONF'
server {
    listen 80;
    server_name _;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:8082/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Connection "";
    }
}
CONF

sudo ln -sf /etc/nginx/sites-available/spring-proxy.conf /etc/nginx/sites-enabled/spring-proxy.conf
sudo nginx -t
sudo systemctl reload nginx

curl -I http://localhost/

