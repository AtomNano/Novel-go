FROM php:8.1-cli

WORKDIR /app

# Install PDO MySQL extension
RUN docker-php-ext-install pdo pdo_mysql

# Set working directory
WORKDIR /var/www

# Copy application files
COPY . /var/www

# Expose port 8000
EXPOSE 8000

# Start PHP built-in server
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
