FROM php:8.2-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    default-mysql-client

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy existing application directory contents
COPY . /var/www

# Install dependencies
RUN composer install --no-interaction --optimize-autoloader

# Copy .env.example to .env if not exists
RUN if [ ! -f .env ]; then cp .env.example .env; fi

# Set permissions
RUN chown -R www-data:www-data /var/www/storage
RUN chmod -R 775 /var/www/storage

# Expose port 8080
EXPOSE 8080

# Start PHP built-in server
CMD php artisan migrate --force && php -S 0.0.0.0:8080 -t public
