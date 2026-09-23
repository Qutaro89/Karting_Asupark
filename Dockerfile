FROM php:8.2-apache

RUN docker-php-ext-install mysqli pdo_mysql \
    && a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

WORKDIR /var/www/html

COPY php/ /var/www/html/asupark/

RUN chown -R www-data:www-data /var/www/html/asupark

EXPOSE 80