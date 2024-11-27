FROM php:8.2-fpm
LABEL authors="Nomercy"
RUN apt-get update && apt-get install -y \
      supervisor \
      libpq-dev \
      libpng-dev \
      libjpeg-dev \
      libzip-dev \
      zip unzip \
      git \
      curl \
      gnupg2 \
      libicu-dev \
    && docker-php-ext-install pdo_mysql bcmath gd zip intl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

RUN node -v && npm -v
# Copy composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /var/www
COPY . .
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]

