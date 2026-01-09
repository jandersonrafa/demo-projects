FROM php:8.2-cli
RUN apt-get update && apt-get install -y libzip-dev zip unzip libpq-dev && \
    docker-php-ext-install zip pdo_pgsql pcntl && \
    pecl install apcu openswoole && docker-php-ext-enable apcu openswoole
RUN echo "apc.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /app
COPY . .
RUN composer require laravel/octane -W
RUN composer update --no-dev --optimize-autoloader
RUN php artisan octane:install --server=swoole
CMD ["php", "artisan", "octane:start", "--server=swoole", "--host=0.0.0.0", "--port=8000", "--workers=auto"]
