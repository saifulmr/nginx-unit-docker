
# NGINX Unit 1.31.1-1 + PHP 8.2 + Alpine Linux 3.19

## docker-compose usage:

```docker-compose.yml
version: '3.7'
services:
  unit-php-app:
    build: .
    volumes:
      - ./php_app:/var/www
      - ./unit_config.json:/docker-entrypoint.d/unit_config.json
    environment:
      - TZ=UTC
    restart: always
```

