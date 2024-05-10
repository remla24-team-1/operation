server {
    listen 80;

    location /api/model {
        proxy_pass http://model-service:5000;
    }

    location /result {
        proxy_pass http://app-service:80;
    }
}