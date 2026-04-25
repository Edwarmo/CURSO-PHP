FROM dunglas/frankenphp:php8.2

RUN install-php-extensions gd zip pdo_pgsql pcntl

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

RUN npm ci && npm run build

RUN php artisan key:generate --force \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

CMD php artisan migrate --force && frankenphp php-server --listen :${PORT:-8080} --root /app/public
