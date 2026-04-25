# ============================================================
# Stage 1: Dependencias PHP (sin scripts, sin autoloader)
# ============================================================
FROM composer:latest AS composer-deps
WORKDIR /app
COPY composer.json composer.lock ./
COPY database ./database
RUN composer install \
    --no-interaction \
    --prefer-dist \
    --no-dev \
    --ignore-platform-reqs \
    --no-scripts \
    --no-autoloader

# ============================================================
# Stage 2: Assets frontend con Vite
# ============================================================
FROM node:20-slim AS node-assets
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts
COPY resources ./resources
COPY public ./public
COPY vite.config.js ./
COPY jsconfig.json ./
COPY tailwind.config.js ./
COPY postcss.config.js ./
COPY --from=composer-deps /app/vendor ./vendor
RUN npm run build

# ============================================================
# Stage 3: Imagen final de producción
# ============================================================
FROM dunglas/frankenphp:php8.4
WORKDIR /app
RUN install-php-extensions gd zip pdo_pgsql pcntl dom
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY --from=composer-deps /app/vendor ./vendor
COPY --from=node-assets /app/public/build ./public/build
COPY . .
RUN mkdir -p bootstrap/cache \
            storage/framework/cache \
            storage/framework/sessions \
            storage/framework/views \
            storage/logs \
    && chmod -R 775 bootstrap/cache storage
RUN composer dump-autoload --optimize --no-dev --no-scripts && \
    rm /usr/bin/composer && \
    php artisan package:discover --ansi && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache
EXPOSE 8080
CMD php artisan migrate --force && frankenphp php-server --listen :${PORT:-8080} --root /app/public
