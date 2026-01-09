FROM php:8.1-cli

WORKDIR /app

# Install git and unzip for Composer
RUN apt-get update && apt-get install -y git unzip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy only composer files first for caching
# COPY composer.json composer.lock ./ (Skipping for manual mock setup)

COPY . .

# Install dependencies
RUN composer install

EXPOSE 8000

CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
