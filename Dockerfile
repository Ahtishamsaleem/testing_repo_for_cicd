# Use the Bitnami Laravel image as the base image
FROM docker.io/bitnami/laravel:10

# Set the working directory to the app directory
WORKDIR /app

# Copy the composer.json and composer.lock files and install dependencies
COPY composer.json composer.lock ./

#  --mount option to cache the Composer cache directory in a Docker volume.
#  The composer install and composer dump-autoload commands will use the cached directory if it already exists,
#  and only update it if the composer.json or composer.lock files have changed.
RUN --mount=type=cache,target=/root/.composer/cache composer install --no-scripts --prefer-dist --no-progress --no-autoloader

# Copy the rest of the application files
COPY . .

# Generate the autoload files
RUN --mount=type=cache,target=/root/.composer/cache composer dump-autoload --no-scripts  --optimize

# Set the file permissions
RUN chown -R bitnami:daemon /app/storage && chown -R bitnami:daemon /app/bootstrap/cache
# Install laravel/ui package
RUN composer require laravel/ui

# Generate the authentication scaffolding
RUN php artisan ui vue --auth

# Expose port 8000 and start the PHP server
EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]

# Install database extension
# RUN apt-get update && apt-get install -y \
#     mariadb-client \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# Set the database environment variables
# ENV DB_CONNECTION=mysql
# ENV DB_HOST=salesflo-pay-demo.csjwzpx6igxp.us-east-1.rds.amazonaws.com
# ENV DB_PORT=3306
# ENV DB_DATABASE=salesflo-pay
# ENV DB_USERNAME=admin
# ENV DB_PASSWORD=Salesflopay2022
