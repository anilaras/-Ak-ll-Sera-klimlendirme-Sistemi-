# PHP API için Dockerfile
FROM php:8.2-apache

# Sistem paketlerini güncelle ve gerekli paketleri yükle
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_mysql zip

# Apache mod_rewrite'ı etkinleştir
RUN a2enmod rewrite
RUN a2enmod headers

# PHP ayarlarını güncelle
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Çalışma dizinini ayarla
WORKDIR /var/www/html

# Composer'ı yükle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Apache configurasyonunu güncelle
RUN echo '<Directory /var/www/html>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/docker-php.conf \
    && a2enconf docker-php

# TimeZone ayarla
ENV TZ=Europe/Istanbul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# PHP memory limit ve upload size ayarları
RUN echo "memory_limit=256M" > /usr/local/etc/php/conf.d/memory-limit.ini
RUN echo "upload_max_filesize=10M" > /usr/local/etc/php/conf.d/upload-limit.ini
RUN echo "post_max_size=10M" >> /usr/local/etc/php/conf.d/upload-limit.ini

# Apache'yi ön planda çalıştır
CMD ["apache2-foreground"]
