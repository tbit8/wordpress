FROM php:7.4-fpm

# Set the working directory to /app
WORKDIR /var/www/html

# Install any needed packages
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

# Install PHP extensions required by WordPress
RUN docker-php-ext-install mysqli pdo_mysql

# Download and install WordPress
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz

# Set up Nginx configuration
COPY nginx.conf /etc/nginx/sites-available/default

# Expose port 80
EXPOSE 80

# Start Nginx and PHP-FPM
CMD service nginx start && php-fpm
