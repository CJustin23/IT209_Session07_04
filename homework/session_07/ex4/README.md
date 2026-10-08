# Bài 4: Cấu hình Reverse Proxy Nginx cho ứng dụng Spring Boot

## 1. Tạo trang tĩnh

```bash
sudo mkdir -p /var/www/html
sudo nano /var/www/html/index.html
```

Nội dung mẫu:

```html
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Spring Boot Proxy Demo</title>
</head>
<body>
    <h1>Thông tin học viên</h1>
    <p><strong>Họ tên:</strong> Nguyễn Văn A</p>
    <p><strong>Mã lớp:</strong> IT209</p>
</body>
</html>
```

## 2. Tạo file cấu hình Nginx

```bash
sudo nano /etc/nginx/sites-available/spring-proxy.conf
```

```nginx
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
```

## 3. Kích hoạt cấu hình

```bash
sudo ln -s /etc/nginx/sites-available/spring-proxy.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 4. Kiểm tra

```bash
sudo nginx -t
curl -I http://localhost/
curl -I http://localhost/api/health
```

### Kết quả mong đợi

```text
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

```text
HTTP/1.1 200 OK
```

```text
HTTP/1.1 200 OK
```

Lưu ý: môi trường hiện tại là Windows nên không thể chạy trực tiếp `nginx` và `curl` ở đây. File này chứa cấu hình chuẩn và lệnh kiểm tra chuẩn để chạy trên máy Linux thật.

