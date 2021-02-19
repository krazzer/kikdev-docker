FROM mileschou/phalcon:7.4-apache

MAINTAINER Kaz van Wel <info@kiksaus.nl>

ENV PATH /usr/local/go/bin:$PATH

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
RUN pecl install APCu-5.1.18
RUN docker-php-ext-enable apcu

# install mbstring
RUN apt-get update -y && apt-get install -y libcurl3-dev libzip-dev libssh2-1-dev libonig-dev && pecl install ssh2-1.2
RUN docker-php-ext-install mbstring
RUN docker-php-ext-enable mbstring

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

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
        -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=NL/ST=Holland/L=Alkmaar/O=Kiksaus/OU=Development/CN=kiksaus"

RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod ssl

RUN a2ensite default-ssl

    # install go
RUN apt-get update
RUN apt-get install --no-install-recommends --assume-yes --quiet ca-certificates curl git
RUN rm -rf /var/lib/apt/lists/*

RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -

#install mhsendmail, needed for mailh
RUN go get github.com/mailhog/mhsendmail
RUN cp /root/go/bin/mhsendmail /usr/bin/mhsendmail

#errorlog conf
RUN echo "log_errors = on" >> /usr/local/etc/php/php.ini
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/php.ini
RUN echo "error_log = /var/log/apache2/php_error.log" >> /usr/local/etc/php/php.ini
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/php.ini
RUN echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/php.i

# install ping, vim & tzdata
RUN apt-get update -y \
    && apt-get install -y iputils-ping \
    && apt-get install -y vim \
    && apt-get install -y tzdata

# install xdebug
RUN pecl install xdebug

# set servername
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 80
EXPOSE 443