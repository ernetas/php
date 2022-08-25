# syntax=docker/dockerfile:1.4.1
FROM php:8.1-fpm
ENV APT_LISTCHANGES_FRONTEND mail
ENV DEBIAN_FRONTEND noninteractive
ENV PHP_OPENSSL=yes
RUN <<EOF
#!/bin/bash
apt-get update
apt-get dist-upgrade -y
apt-get install -y -o DPkg::options::='--force-confdef' -o Dpkg::Options::='--force-confold' \
  curl \
  git \
  imagemagick \
  libc-client-dev \
  libc-client2007e \
  libc-client2007e-dev \
  libcurl4 \
  libgnutls28-dev \
  libgraphicsmagick1-dev \
  libicu-dev \
  libkrb5-dev \
  libmagickwand-dev \
  libmariadbclient-dev-compat \
  libzip-dev \
  libcurl4-openssl-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  libpng-tools \
  libpng16-16 \
  wget \
apt-get clean
apt-get autoremove -y
docker-php-ext-install -j$(nproc) pdo_mysql mysqli zip iconv intl curl
pecl install imagick
docker-php-ext-enable imagick
docker-php-ext-configure gd
docker-php-ext-configure imap --with-kerberos --with-imap-ssl
docker-php-ext-install -j$(nproc) gd imap
rm -rf /var/lib/apt/lists/*
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