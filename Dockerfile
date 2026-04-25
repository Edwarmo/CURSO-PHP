# Stage 1: dependencias PHP
FROM composer:latest AS composer-deps
WORKDIR /app
COPY composer.json composer.lock ./
COPY database ./database
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev --ignore-platform-reqs

# Stage 2: compilar assets con Vite (Node puro, vendor copiado para ziggy)
FROM node:20-slim AS node-assets
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts
COPY resources ./resources
COPY public ./public
COPY vite.config.js jsconfig.json tailwind.config.js postcss.config.js ./
# ziggy necesita vendor/tightenco para generar su módulo JS
COPY --from=composer-deps /app/vendor/tightenco ./vendor/tightenco
RUN npm run build

# Stage 3: imagen final FrankenPHP PHP 8.4 (sin Node, sin Composer)
FROM dunglas/frankenphp:php8.4
RUN install-php-extensions gd zip pdo_pgsql pcntl dom
WORKDIR /app
COPY . .
COPY --from=composer-deps /app/vendor ./vendor
COPY --from=node-assets /app/public/build ./public/build
RUN php artisan key:generate --force \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache
CMD php artisan migrate --force && frankenphp php-server --listen :${PORT:-8080} --root /app/public
