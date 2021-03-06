FROM php:7.1.7-fpm-alpine
WORKDIR /var/www

## Dependencies ##
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
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

# Install the php memcached extension
ARG INSTALL_MEMCACHED=true
RUN if [ ${INSTALL_MEMCACHED} = true ]; then \
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

# Install Php Redis Extension
ARG INSTALL_PHPREDIS=true
RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis \
;fi

ARG INSTALL_MONGO=true
RUN if [ ${INSTALL_MONGO} = true ]; then \
    mkdir -p /usr/src/php/ext && \
    wget http://pecl.php.net/get/mongodb-1.2.8.tgz && \
    tar -C /usr/src/php/ext -xf mongo*.tgz && \
    rm mongo*.tgz && \
    mv /usr/src/php/ext/mongo* /usr/src/php/ext/mongodb && \
    docker-php-ext-install mongodb \
;fi

## Extensions ##
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd iconv opcache pdo_mysql tokenizer mcrypt mysqli sockets
    
## phpmyadmin ##
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com && \ 
    composer create-project phpmyadmin/phpmyadmin --repository-url=https://packagist.phpcomposer.com --no-dev
COPY ./phpmyadmin/config.inc.php phpmyadmin/

##supervisor##
ENV PYTHON_VERSION=2.7.12-r0
ENV PY_PIP_VERSION=8.1.2-r0
ENV SUPERVISOR_VERSION=3.3.1
RUN apk update && apk add -u python=$PYTHON_VERSION py-pip=$PY_PIP_VERSION && \
    pip install supervisor==$SUPERVISOR_VERSION && mkdir -p /etc/supervisor && touch /etc/supervisor/default.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf

COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./default.ini /usr/local/etc/php/conf.d/default.ini 
ARG TIMEZONE=Asia/Shanghai
RUN echo "date.timezone=${TIMEZONE}" >> /usr/local/etc/php/conf.d/default.ini && \
    echo ${TIMEZONE} > /etc/timezone
COPY ./crontab /etc/crontabs/root
COPY ./run.sh /var/
RUN chmod +x /var/run.sh
VOLUME [ "/var/www" , "/etc/supervisor/conf.d" ]
CMD ["/var/run.sh"]