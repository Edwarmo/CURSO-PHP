# Stage 1: dependencias PHP sin scripts que requieran artisan
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

# Stage 2: compilar assets con Vite (solo Node)
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

# Stage 3: imagen final FrankenPHP PHP 8.4 (sin Node, sin Composer)
FROM dunglas/frankenphp:php8.4
RUN install-php-extensions gd zip pdo_pgsql pcntl dom
WORKDIR /app

# Copiar código fuente
COPY . .

# Copiar vendor y assets compilados
COPY --from=composer-deps /app/vendor ./vendor
COPY --from=node-assets /app/public/build ./public/build

# Generar autoloader y descubrir paquetes (artisan ya está disponible)
RUN composer dump-autoload --optimize --no-dev --no-scripts
RUN php artisan package:discover --ansi

# Cachear configuración para producción
RUN php artisan key:generate --force \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

CMD php artisan migrate --force && frankenphp php-server --listen :${PORT:-8080} --root /app/public
