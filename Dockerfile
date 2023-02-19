# syntax=docker/dockerfile:1.5.2
FROM php:8.2-fpm-alpine
ENV PHP_OPENSSL=yes
RUN <<EOF
#!/bin/sh
apk add --no-cache curl wget git bash
apk add --no-cache --virtual .build-deps build-base icu-dev libzip-dev autoconf imagemagick-libs imagemagick-dev icu-libs libc-dev libpng-dev curl-dev imap-dev krb5-dev
docker-php-ext-install -j$(nproc) pdo_mysql mysqli zip intl curl
pecl install imagick
docker-php-ext-enable imagick
docker-php-ext-configure gd
docker-php-ext-configure imap --with-kerberos --with-imap-ssl
docker-php-ext-install -j$(nproc) gd imap
curl --output composer -Ss https://getcomposer.org/composer-stable.phar
mv composer /usr/bin/composer
chmod 755 /usr/bin/composer
chown root:root /usr/bin/composer
/usr/bin/composer --version
curl --output /etc/ssl/certs/rds.pem https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem
curl --output wp -Ss https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
mv wp /usr/bin/wp
chmod 755 /usr/bin/wp
chown root:root /usr/bin/wp
/usr/bin/wp --info
EOF
