# Base image
FROM php:7.4-apache

# Set the working directory in the container
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        libpng-dev \
        libonig-dev \
        libxml2-dev \
        zip \
        unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the Laravel project files to the working directory
COPY . /var/www/html

# Set permissions for Laravel directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Install project dependencies using Composer
RUN composer install --optimize-autoloader --no-dev

# Generate the application key
RUN php artisan key:generate

# Set up Apache configuration
COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Expose the container port
EXPOSE 80

# Start the Apache server
CMD ["apache2-foreground"]
