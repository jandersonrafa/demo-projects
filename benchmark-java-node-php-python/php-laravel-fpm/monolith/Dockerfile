FROM php:8.2-fpm

RUN apt-get update && apt-get install -y libzip-dev zip unzip libpq-dev && \
    docker-php-ext-install zip pdo_pgsql pcntl opcache && \
    pecl install apcu && docker-php-ext-enable apcu

RUN echo "apc.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
RUN echo "opcache.jit_buffer_size=100M" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
RUN echo "opcache.jit=1255" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer update --no-dev --optimize-autoloader
RUN echo "catch_workers_output = yes" >> /usr/local/etc/php-fpm.d/www.conf && \
    echo "decorate_workers_output = no" >> /usr/local/etc/php-fpm.d/www.conf && \
    echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf && \
    echo "php_flag[display_errors] = off" >> /usr/local/etc/php-fpm.d/www.conf

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
