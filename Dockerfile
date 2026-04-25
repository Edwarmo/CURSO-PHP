# Stage 1: compilar assets JS/CSS con Node (sin PHP)
FROM node:20-slim AS assets
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
# ziggy genera su archivo desde vendor, lo copiamos en el siguiente stage
# pero vite solo necesita el archivo ziggy.js generado en public/
RUN mkdir -p vendor/tightenco && echo '{}' > vendor/tightenco/ziggy/dist/index.js || true
RUN npm run build || true

# Stage 2: instalar dependencias PHP y compilar assets con vendor real
FROM dunglas/frankenphp:php8.4

# Instalar extensiones necesarias para Laravel 12
RUN install-php-extensions gd zip pdo_pgsql pcntl dom

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copiar todo el proyecto
COPY . .

# Instalar dependencias PHP con autoloader optimizado
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# Ahora compilar assets con vendor real disponible (ziggy puede resolverse)
RUN apt-get update && apt-get install -y nodejs npm && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY package.json package-lock.json ./
RUN npm ci && npm run build

# Configurar Laravel para producción
RUN php artisan key:generate --force \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

CMD php artisan migrate --force && frankenphp php-server --listen :${PORT:-8080} --root /app/public
