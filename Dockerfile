ARG ARCH
ARG VERSION=7.4

FROM --platform=$ARCH php:$VERSION-fpm


# Download script to install PHP extensions and dependencies
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

RUN DEBIAN_FRONTEND=noninteractive apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
    apt-utils curl zip unzip apt-transport-https libicu-dev git \
    && install-php-extensions bcmath bz2 calendar exif gd intl ldap memcached mysqli opcache \
    pdo_mysql zip gettext redis igbinary sockets

RUN apt-get update && apt-get install -y locales locales-all

RUN pecl install apcu \
    && pecl install apcu_bc-1.0.3 \
    && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
    && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini

RUN yes | pecl install xdebug \
    && pecl enable xdebug

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer
ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1
