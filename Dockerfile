ARG ARCH
ARG VERSION=7.4

FROM --platform=$ARCH php:$VERSION-fpm

RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
    apt-utils curl zip unzip apt-transport-https libicu-dev git \
    locales locales-all

RUN apt-get install -y libbz2-dev libcurl4-openssl-dev zlib1g-dev libpng-dev \
    libldap2-dev libonig-dev libedit-dev libxml2-dev libzip-dev libmemcached-dev

RUN docker-php-ext-install -j$(nproc) bcmath bz2 calendar curl exif gd gettext \
    intl ldap mbstring mysqli opcache pdo_mysql session sockets \
    xml zip && \
    docker-php-ext-enable bcmath bz2 calendar curl exif gd gettext \
    intl ldap mbstring mysqli opcache pdo_mysql session sockets \
    xml zip

RUN pecl install igbinary memcached xdebug && \
    pecl enable igbinary memcached xdebug

RUN apt-get remove -y  libbz2-dev libcurl4-openssl-dev zlib1g-dev libpng-dev \
    libldap2-dev libonig-dev libedit-dev libxml2-dev libzip-dev libmemcached-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer
