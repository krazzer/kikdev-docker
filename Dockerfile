FROM mileschou/phalcon:7.1-apache

MAINTAINER Kaz van Wel <info@kiksaus.nl>

ENV PATH /usr/local/go/bin:$PATH

RUN apt-get upgrade -y && apt-get update -y \
    && apt-get install -y locales \
    && echo "en_US UTF-8" >> /etc/locale.gen \
    && echo "en_GB UTF-8" >> /etc/locale.gen \
    && echo "nl_NL UTF-8" >> /etc/locale.gen \

    && locale-gen \
    && docker-php-ext-install pdo_mysql \

    && apt-get update -y \
    && apt-get install -y libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
	&& docker-php-ext-enable imagick \
	&& pecl install xdebug \
    && docker-php-ext-enable xdebug \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-enable mysqli \
	&& pecl install APCu-5.1.8 \
	&& docker-php-ext-enable apcu \

    # install GD
    && apt-get update -y \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \

    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
        -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=NL/ST=Holland/L=Alkmaar/O=Kiksaus/OU=Development/CN=kiksaus" \

    && a2enmod rewrite \
    && a2enmod headers \
    && a2enmod ssl \

    && a2ensite default-ssl \



    # install go
    && apt-get update \
    && apt-get install --no-install-recommends --assume-yes --quiet ca-certificates curl git \
    && rm -rf /var/lib/apt/lists/* \

    && curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf - \

    # install mhsendmail, needed for mailhog


    && go get github.com/mailhog/mhsendmail \
    && cp /root/go/bin/mhsendmail /usr/bin/mhsendmail \

    # errorlog config
    && echo "log_errors = on" >> /usr/local/etc/php/php.ini \
    && echo "error_reporting = E_ALL" >> /usr/local/etc/php/php.ini \
    && echo "error_log = /var/log/apache2/php_error.log" >> /usr/local/etc/php/php.ini \

    # xdebug config
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/php.ini

EXPOSE 80
EXPOSE 443