FROM php:8.3-cli
RUN apt-get update && apt-get install -y libzip-dev zip unzip libpq-dev && \
    docker-php-ext-install zip pdo_pgsql pcntl opcache && \
    pecl install apcu openswoole && docker-php-ext-enable apcu openswoole
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=0'; \
        echo 'opcache.validate_timestamps=0'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
        echo 'opcache.jit_buffer_size=128M'; \
        echo 'opcache.jit=1255'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini
RUN echo "apc.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini

RUN { \
        echo 'realpath_cache_size=4096K'; \
        echo 'realpath_cache_ttl=600'; \
        echo 'memory_limit=256M'; \
        echo 'expose_php=Off'; \
    } > /usr/local/etc/php/conf.d/zz-production.ini
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /app
COPY . .
RUN composer require laravel/octane -W
RUN composer update --no-dev --optimize-autoloader
RUN php artisan octane:install --server=swoole

ENV APP_ENV=production APP_KEY=base64:u8MvK+1512zU2m6XvP3Yv1rK8Z5o8z8k9u0u1u2u3u4=
RUN php artisan route:cache && php artisan view:cache

CMD ["sh", "-c", "php artisan config:cache && php artisan octane:start --server=swoole --host=0.0.0.0 --port=8000 --workers=${OCTANE_WORKERS:-auto} ${OCTANE_MAX_REQUESTS:+--max-requests=$OCTANE_MAX_REQUESTS}"]