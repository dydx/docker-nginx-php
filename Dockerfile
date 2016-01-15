# NAME: nginx-php
# VERSION: 0.0.1
#
# Basic Nginx PHP-FPM Build
#
FROM ubuntu:latest

#Environment
ENV PHP php-7.0.0
ENV PHP_PATH /opt/$PHP

RUN apt-get -y update
RUN apt-get -y install nano curl wget \
		build-essential python-software-properties \
		libfcgi-dev libmcrypt-dev libssl-dev \
		libfcgi0ldbl libjpeg-dev libpng12-dev \
		libc-client2007e libc-client2007e-dev \
		libxml2-dev libxslt1-dev libbz2-dev \
		libcurl4-openssl-dev libfreetype6-dev \
		libkrb5-dev libpq-dev \
		supervisor insserv

RUN mkdir -p /opt/$PHP
RUN wget http://de1.php.net/get/$PHP.tar.bz2/from/this/mirror -O $PHP.tar.bz2
RUN tar -xvf $PHP.tar.bz2

RUN ln -s /usr/lib/libc-client.a /usr/lib/x86_64-linux-gnu/libc-client.a

RUN /$PHP/configure --prefix=$PHP_PATH --with-pdo-pgsql --with-zlib-dir --with-freetype-dir --enable-mbstring --with-libxml-dir=/usr --enable-soap --enable-calendar --with-curl --with-mcrypt --with-zlib --with-gd --with-pgsql --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif --enable-bcmath --with-mhash --enable-zip --with-pcre-regex --with-pdo-mysql --with-mysqli --with-mysql-sock=/var/run/mysqld/mysqld.sock --with-jpeg-dir=/usr --with-png-dir=/usr --enable-gd-native-ttf --with-openssl --with-fpm-user=www-data --with-fpm-group=www-data --with-libdir=/lib/x86_64-linux-gnu --enable-ftp --with-imap --with-imap-ssl --with-kerberos --with-gettext --with-xmlrpc --with-xsl --enable-opcache --enable-fpm

RUN make && make install

RUN rm -Rf /$PHP.tar.bz2

RUN apt-get -y install nginx
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default /etc/nginx/sites-enabled/default
COPY php/www.conf $PHP_PATH/etc/php-fpm.d/www.conf
COPY php/php-fpm.conf $PHP_PATH/etc/php-fpm.conf

ENV PATH=$PATH:$PHP_PATH

#Set up services
COPY php/php-fpm /etc/init.d/php-fpm
RUN chmod 755 /etc/init.d/php-fpm
RUN chown root:root /etc/init.d/php-fpm
RUN /usr/lib/insserv/insserv /etc/init.d/php-fpm && /usr/lib/insserv/insserv /etc/init.d/nginx
