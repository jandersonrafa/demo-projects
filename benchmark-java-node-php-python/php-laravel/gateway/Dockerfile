FROM php:8.2-cli
RUN apt-get update && apt-get install -y libzip-dev zip unzip libpq-dev && \
    docker-php-ext-install zip pdo_pgsql pcntl && \
    pecl install apcu && docker-php-ext-enable apcu
RUN echo "apc.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /app
COPY . .
RUN composer update --no-dev --optimize-autoloader
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
