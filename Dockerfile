FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libzip-dev libpq-dev \
    zip unzip git curl nodejs npm \
    && docker-php-ext-install gd zip pdo pdo_pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock ./
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

COPY package.json package-lock.json ./
RUN npm ci && npm run build

COPY . .

RUN php artisan key:generate --force \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

CMD php artisan migrate --force && php -S 0.0.0.0:${PORT:-8080} -t /var/www/html/public
