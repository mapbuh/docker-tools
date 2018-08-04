server {
        listen                     443 ssl http2;
        server_name example.com www.example.com;

        ssl                        on;
        ssl_protocols              TLSv1 TLSv1.1 TLSv1.2;
        ssl_certificate            /etc/letsencrypt/live/example.com/fullchain.pem;
        ssl_certificate_key        /etc/letsencrypt/live/example.com/privkey.pem;

        proxy_connect_timeout       600;
        proxy_send_timeout          600;
        proxy_read_timeout          600;
        send_timeout                600;

        location / {
                proxy_pass          http://127.0.0.1:8002;
                proxy_set_header    Host      $host;
                proxy_set_header    X-Real-IP $remote_addr;
                proxy_set_header    X-HTTPS   'True';
                proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header    X-Forwarded-Proto https;
                proxy_set_header    X-Forwarded-Host $remote_addr;
        }
}
server {
        server_name example.com www.example.com;

        proxy_connect_timeout       600;
        proxy_send_timeout          600;
        proxy_read_timeout          600;
        send_timeout                600;

        location / {
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header    X-Forwarded-Host $remote_addr;
                proxy_pass http://127.0.0.1:8002;
        }
}

