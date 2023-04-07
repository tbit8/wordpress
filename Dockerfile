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
    
#RUN rm /var/www/html/wp-admin/setup-config.php

COPY wp-config.php /var/www/html

RUN ls /var/www/html

RUN apt-get update && apt-get install net-tools wget && \
    wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/local/bin/cloud_sql_proxy && \ 
    chmod +x /usr/local/bin/cloud_sql_proxy
    

# Set up Nginx configuration
COPY nginx.conf /etc/nginx/sites-available/default

RUN sudo chown -R www-data: /var/www/html

# Expose port 80
EXPOSE 80

# Start Nginx and PHP-FPM
CMD service nginx start && php-fpm
