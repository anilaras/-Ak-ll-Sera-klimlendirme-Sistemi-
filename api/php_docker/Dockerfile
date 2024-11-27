FROM php:8.2-fpm

# Installing dependencies for building the PHP modules
RUN apt update && \
    apt install -y zip libzip-dev libpng-dev libicu-dev libxml2-dev

# Installing additional PHP modules
RUN docker-php-ext-install mysqli pdo pdo_mysql gd zip intl xml

# Cleaning APT cache
RUN apt clean