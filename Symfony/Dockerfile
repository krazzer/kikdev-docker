FROM php:8.4-apache

# install opcache
RUN docker-php-ext-install opcache && \
    echo "opcache.enable=1" > /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.interned_strings_buffer=8" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.max_accelerated_files=10000" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.validate_timestamps=1" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.revalidate_freq=2" >> /usr/local/etc/php/conf.d/opcache.ini

# install intl
RUN apt-get update  \
    && apt-get install -y apt-transport-https \
    && apt-get install -y libicu-dev \
    && apt-get install -y libonig-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-enable intl \
    && apt-get clean all

# Install dependencies for mbstring & imagick
RUN apt-get update && apt-get install -y \
        libicu-dev \
        libonig-dev \
        libpq-dev \
        libzip-dev \
        unzip \
        libmagickwand-dev --no-install-recommends \
        && pecl install imagick \
        && docker-php-ext-enable imagick \
        && docker-php-ext-install mbstring \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/local/go/bin:$PATH

RUN apt-get upgrade -y && apt-get update -y
RUN apt-get install -y locales
RUN echo "en_US UTF-8" >> /etc/locale.gen
RUN echo "en_GB UTF-8" >> /etc/locale.gen
RUN echo "nl_NL UTF-8" >> /etc/locale.gen
RUN apt-get clean all

RUN locale-gen
RUN docker-php-ext-install pdo_mysql

# install mysqli & APCu
RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable mysqli
RUN pecl install apcu
RUN docker-php-ext-enable apcu

# install zip
RUN apt-get update
RUN apt-get install -y zlib1g-dev libzip-dev
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip
RUN docker-php-ext-enable zip
RUN apt-get clean all

# install GD
RUN apt-get update -y
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd
RUN apt-get clean all

# install bcmath
RUN docker-php-ext-install bcmath

# install Soap Client
RUN apt-get update
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
        -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=NL/ST=Holland/L=Hollands Kroon/O=Kiksaus/OU=Development/CN=kiksaus"

RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod ssl

RUN a2ensite default-ssl
RUN apt-get clean all

# install go
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://go.dev/dl/go1.21.3.linux-amd64.tar.gz -o /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

# install mhsendmail, needed for mailh
RUN /usr/local/go/bin/go install github.com/mailhog/mhsendmail@latest \
    && cp /root/go/bin/mhsendmail /usr/local/bin/mhsendmail

# errorlog conf
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
RUN apt-get update -y && apt-get install -y iputils-ping && apt-get install -y vim && apt-get install -y tzdata
RUN apt-get clean all

# install xdebug
RUN pecl install xdebug-3.4.1 && apt-get clean all

# set servername
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# set document root
RUN rmdir /var/www/html
RUN mkdir -p /var/www/public_html
RUN chown -R www-data:www-data /var/www/public_html
VOLUME ["/var/www/public_html"]
WORKDIR /var/www/public_html

ENV APACHE_DOCUMENT_ROOT=/var/www/public_html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# enable xdebug
RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20240924/xdebug.so" >> /usr/local/etc/php/php.ini

RUN apache2ctl restart

EXPOSE 80
EXPOSE 443