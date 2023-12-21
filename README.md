
# NGINX Unit 1.31.1-1 + PHP 8.2 + Alpine Linux 3.19

## Change ownership of application files

 - Copy php application files to ./php_app directory
 - Change permissions of application files, because unit is running as user unit (id=2002)
```bash
sudo chown -R 2002 ./php_app
sudo chown 2002 ./unit_config.json
```

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


## Build options

```build
~# unit --version
unit version: 1.31.1
configured as ./configure --prefix=/usr --modulesdir=/usr/lib/unit/modules --state=/var/lib/unit --control=unix:/var/run/control.unit.sock --pid=/var/run/unit.pid --log=/var/log/unit.log --tmp=/var/tmp --user=unit --group=unit --openssl --libdir=/usr/lib
```
````php
~# php -v
PHP 8.2.13 (cli) (built: Dec 16 2023 04:34:15) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.2.13, Copyright (c) Zend Technologies
````
````phpm
~# php -m
[PHP Modules]
Core
ctype
curl
date
dom
fileinfo
filter
ftp
hash
iconv
json
libxml
mbstring
mysqlnd
openssl
pcre
PDO
pdo_sqlite
Phar
posix
random
readline
Reflection
session
SimpleXML
sodium
SPL
sqlite3
standard
tokenizer
xml
xmlreader
xmlwriter
zlib
````