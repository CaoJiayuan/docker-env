FROM php:7.1.7-fpm-alpine
WORKDIR /var/www

## Dependencies ##
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk --update add libmcrypt-dev \
    wget \
    git \
    freetype-dev \
    libjpeg-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    autoconf \
    gcc \
    libc6-compat \
    g++ make libffi-dev openssl-dev

## Composer ##
RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/bin/composer && \
    php -r "unlink('composer-setup.php');"

ARG INSTALL_MEMCACHED=false
RUN if [ ${INSTALL_MEMCACHED} = true ]; then \
    # Install the php memcached extension
    apk --update add cyrus-sasl-dev libmemcached-dev zlib-dev \
    && curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p memcached \
    && tar -C memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && ( \
        cd memcached \
        && phpize \
        && ./configure --disable-memcached-sasl \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r memcached \
    && rm /tmp/memcached.tar.gz \
    && docker-php-ext-enable memcached \
;fi

ARG INSTALL_PHPREDIS=false
RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    # Install Php Redis Extension
    pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis \
;fi

## Extensions ##
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd iconv opcache pdo_mysql tokenizer mcrypt mysqli
    
## phpmyadmin ##
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com && \
    composer create-project phpmyadmin/phpmyadmin --no-dev
COPY ./phpmyadmin/config.inc.php /var/www/phpmyadmin/

COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./default.ini /usr/local/etc/php/conf.d/default.ini 
ARG TIMEZONE=UTC
RUN echo "date.timezone=${TIMEZONE}" >> /usr/local/etc/php/conf.d/default.ini
