FROM php:8.2-fpm

# Встановлення залежностей
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip

# Встановлення розширень PHP
RUN docker-php-ext-install pdo pdo_mysql zip
RUN pecl install redis protobuf grpc \
    && docker-php-ext-enable redis protobuf grpc

# Встановлення Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Копіювання файлів проекту
COPY . /var/www/html

# Встановлення залежностей проекту
RUN cd /var/www/html && composer install --no-dev --no-interaction

# Налаштування прав доступу
RUN chown -R www-data:www-data /var/www/html/storage

# Відкриття порту
EXPOSE 9000

CMD ["php-fpm"]
