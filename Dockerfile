# NAME: nginx-php
# Basic Nginx PHP-FPM Build
FROM alpine:3.5
COPY repositories /etc/apk/repositories
#Environment

RUN apk update \
 && apk upgrade \
 && apk add \
    autoconf \
    bash \
    ca-certificates \
    curl \
    g++ \
    git \
    libressl \
    make \
    musl \
    musl-dev \
    musl-utils \
    nginx \
    libwebp \
    php7@community \
    php7-apcu@community \
    php7-dom@community \
    php7-fpm@community \
    php7-openssl@community \
    php7-mcrypt@community \
    php7-zlib@community \
    php7-ctype@community \
    php7-curl@community \
    php7-bz2@community \
    php7-gd@community \
    php7-iconv@community \
    php7-json@community \
    php7-mbstring@community \
    php7-mysqli@community \
    php7-opcache@community \
    php7-openssl@community \
    php7-pdo@community \
    php7-pdo_mysql@community \
    php7-phar@community \
    php7-session@community \
    php7-xdebug@community \
    shadow@community \
    tar \
 && rm -rf /var/cache/apk/* \
 && rm -rf /tmp/* \
 && ln -s /usr/bin/php7 /usr/bin/php

# Install Composer
RUN mkdir -p /etc/ssl/certs/ \
 && update-ca-certificates --fresh \
 && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer

# Ensure $HOME is set
ENV HOME /root
# Create www-data user
RUN adduser -S www-data -G www-data \
 && usermod -u 1000 www-data
