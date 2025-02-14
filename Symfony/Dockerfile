FROM php:8.3-apache

ARG PSR_VERSION=1.2.0

# install intl
RUN apt-get update  \
    && apt-get install -y apt-transport-https \
    && apt-get install -y libicu-dev \
    && apt-get install -y libonig-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-enable intl \
    && apt-get clean all

# install imagick
ADD --chmod=0755 \
  https://github.com/mlocati/docker-php-extension-installer/releases/download/2.6.3/install-php-extensions \
  /usr/local/bin/
# Use latest released version, after https://github.com/Imagick/imagick/issues/640 is fixed
RUN install-php-extensions imagick/imagick@28f27044e435a2b203e32675e942eb8de620ee58

# install mbstring
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libonig-dev \
    libpq-dev \
    libzip-dev \
    unzip && \
    docker-php-ext-install mbstring && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# install psr
RUN cd /tmp \
    && curl -LO https://github.com/jbboehr/php-psr/archive/v${PSR_VERSION}.tar.gz \
    && tar xzf /tmp/v${PSR_VERSION}.tar.gz \
    && docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) /tmp/php-psr-${PSR_VERSION} \
    && rm -r /tmp/v${PSR_VERSION}.tar.gz /tmp/php-psr-${PSR_VERSION}

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
RUN pecl install APCu-5.1.22
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
RUN apt-get update
RUN apt-get install --no-install-recommends --assume-yes --quiet ca-certificates curl git
RUN rm -rf /var/lib/apt/lists/*

RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -
RUN apt-get clean all

# install mhsendmail, needed for mailh
RUN go get github.com/mailhog/mhsendmail
RUN cp /root/go/bin/mhsendmail /usr/bin/mhsendmail

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

RUN apache2ctl restart

EXPOSE 80
EXPOSE 443