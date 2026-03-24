FROM php:8.4-apache

LABEL maintainer="Kaz van Wel <info@kiksaus.nl>"

ARG PSR_VERSION=1.2.0

# Install psr
RUN cd /tmp \
    && curl -LO https://github.com/jbboehr/php-psr/archive/v${PSR_VERSION}.tar.gz \
    && tar xzf /tmp/v${PSR_VERSION}.tar.gz \
    && docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) /tmp/php-psr-${PSR_VERSION} \
    && rm -r /tmp/v${PSR_VERSION}.tar.gz /tmp/php-psr-${PSR_VERSION}

# Install phalcon
COPY phalcon.so /tmp/

RUN cp /tmp/phalcon.so $(php -r 'echo ini_get("extension_dir");') \
    && docker-php-ext-enable phalcon \
    && rm -rf /tmp/phalcon.so

ENV PATH=/usr/local/go/bin:$PATH

RUN apt-get upgrade -y && apt-get update -y
RUN apt-get install -y locales
RUN echo "en_US UTF-8" >> /etc/locale.gen
RUN echo "en_GB UTF-8" >> /etc/locale.gen
RUN echo "nl_NL UTF-8" >> /etc/locale.gen

RUN locale-gen
RUN docker-php-ext-install pdo_mysql

RUN apt-get update -y
RUN apt-get install -y libmagickwand-dev --no-install-recommends
RUN pecl install imagick
RUN docker-php-ext-enable imagick
RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable mysqli
RUN pecl install APCu-5.1.28
RUN docker-php-ext-enable apcu

# install mbstrin
WORKDIR /var/www

    ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && sync && install-php-extensions mbstring


#RUN apt-get update -y && apt-get install -y libcurl3-dev libzip-dev libssh2-1-dev libonig-dev && pecl install ssh2-1.2
#RUN docker-php-ext-install mbstring
#RUN docker-php-ext-enable mbstring

# install zip
RUN apt-get update
RUN apt-get install -y zlib1g-dev libzip-dev
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip
RUN docker-php-ext-enable zip

# install GD
RUN apt-get update -y
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd

# install bcmath
RUN docker-php-ext-install bcmath

# install Soap Client
RUN apt-get update
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
        -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=NL/ST=Holland/L=Alkmaar/O=Kiksaus/OU=Development/CN=kiksaus"

RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod ssl

RUN a2ensite default-ssl

# install go
ARG GO_VERSION=1.21.2

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl git tar gzip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

# Voeg Go toe aan PATH
ENV PATH="/usr/local/go/bin:${PATH}"

# install mhsendmail, needed for mailh
RUN /usr/local/go/bin/go install github.com/mailhog/mhsendmail@latest \
    && cp /root/go/bin/mhsendmail /usr/local/bin/mhsendmail

#errorlog conf
RUN echo "log_errors = on" >> /usr/local/etc/php/php.ini
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/php.ini
RUN echo "error_log = /var/log/apache2/php_error.log" >> /usr/local/etc/php/php.ini
RUN echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/php.ini
RUN echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/php.ini
RUN echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/php.ini
RUN echo "xdebug.client_port=9000" >> /usr/local/etc/php/php.ini
RUN echo "upload_max_filesize = 15M" >> /usr/local/etc/php/php.ini
RUN echo "post_max_size = 30M" >> /usr/local/etc/php/php.ini

# install ping, vim & tzdata
RUN apt-get update -y \
    && apt-get install -y iputils-ping \
    && apt-get install -y vim \
    && apt-get install -y tzdata

# install xdebug
RUN pecl install xdebug-3.5.1

# install intl
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libonig-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

RUN docker-php-ext-enable intl

# Install dependencies for pgsql
RUN apt-get update && apt-get install -y \
        libpq-dev \
    && docker-php-ext-install pdo_pgsql \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_pgsql

# Enable and configure OPcache
RUN docker-php-ext-install opcache \
 && docker-php-ext-enable opcache \
 && echo "opcache.enable=1" >> /usr/local/etc/php/php.ini \
 && echo "opcache.enable_cli=1" >> /usr/local/etc/php/php.ini \
 && echo "opcache.memory_consumption=128" >> /usr/local/etc/php/php.ini \
 && echo "opcache.interned_strings_buffer=8" >> /usr/local/etc/php/php.ini \
 && echo "opcache.max_accelerated_files=10000" >> /usr/local/etc/php/php.ini \
 && echo "opcache.revalidate_freq=0" >> /usr/local/etc/php/php.ini \
 && echo "opcache.validate_timestamps=1" >> /usr/local/etc/php/php.ini

# set servername
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 80
EXPOSE 443