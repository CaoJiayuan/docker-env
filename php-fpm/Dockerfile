FROM php:7.1.7-fpm-alpine
WORKDIR /var/www

## Dependencies ##
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk --update add libmcrypt-dev wget git

## Composer ##
RUN php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/bin/composer && \
    php -r "unlink('composer-setup.php');"

## Extensions ##
RUN docker-php-ext-install pdo_mysql tokenizer mcrypt mysqli

## phpmyadmin ##
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com && \
    composer create-project phpmyadmin/phpmyadmin --no-dev
COPY phpmyadmin /var/www/phpmyadmin/