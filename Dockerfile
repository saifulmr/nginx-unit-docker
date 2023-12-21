FROM php:8.2-alpine3.19
LABEL maintainer="Saiful Alam <saiful.alam@c-serv.net>"
ARG UNIT_VERSION="1.31.1-1"
WORKDIR /tmp
RUN set -ex \
    && apk add --no-cache \
        ca-certificates \
        curl \
        icu \
        pcre2 \
        libpng \
        libzip \
        php82-bcmath \
        php82-bz2 \
        php82-calendar \
        php82-cgi \
        php82-ctype \
        php82-curl \
        php82-dom \
        php82-exif \
        php82-fileinfo \
        php82-gd \
        php82-gmp \
        php82-imap \
        php82-iconv \
        php82-intl \
        php82-mbstring \
        php82-mysqli \
        php82-pdo \
        php82-pdo_mysql	\
        php82-pdo_sqlite \
        php82-session \
        php82-tokenizer	\
        php82-xml \
        php82-xmlwriter \
        php82-xmlreader \
        php82-zip \
        php82-embed	\
    && apk add --no-cache --virtual .build-deps \        
        mercurial \
        build-base \
        openssl-dev \
        oniguruma-dev \
        pcre2-dev \
        pkgconfig \
        libzip-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        icu-dev \
        php82-dev \
    && mkdir -p /usr/lib/unit/modules /usr/lib/unit/debug-modules \
    && mkdir -p /var/www \
    && hg clone -u $UNIT_VERSION https://hg.nginx.org/unit \
    && cd unit \
    && ./configure --prefix=/usr \
        --modulesdir=/usr/lib/unit/modules \
        --state=/var/lib/unit \
        --control=unix:/var/run/control.unit.sock \
        --pid=/var/run/unit.pid \
        --log=/var/log/unit.log \
        --tmp=/var/tmp \
        --user=unit \
        --group=unit \
        --openssl \
        --libdir=/usr/lib \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && ln -s /usr/lib/libphp82.so /usr/lib/libphp.so \
    && ./configure php \
    && make php-install \
    && cd / \
    && rm -rf unit \
    && for f in /usr/sbin/unitd /usr/lib/unit/modules/*.unit.so; do \
        ldd $f | awk '/=>/{print $(NF-1)}' | while read n; do apk info -e $n; done | sort | uniq >> /requirements.apk; \
       done \    
    && addgroup -S unit -g 201 \
    && adduser -S unit -G unit -s /bin/false -u 2002 -h /nonexistent  \
    && apk del build-base \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /requirements.apk \
    && ln -sf /dev/stdout /var/log/unit.log \
    && chown -R unit:unit /var/lib/unit /var/www \
    && chmod -R 777 /var/run

COPY docker-entrypoint.sh /usr/local/bin/
RUN unitd --version; php -v; php -m;
STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
EXPOSE 80
WORKDIR /var/www
USER unit
CMD ["unitd", "--no-daemon", "--control", "unix:/var/run/control.unit.sock"]