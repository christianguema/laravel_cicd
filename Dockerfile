FROM php:8.4

# Définir le répertoire de travail
WORKDIR /projet

# Copier le projet Laravel dans l'image
COPY app .

# Installer les dépendances nécessaires

RUN apt-get update && apt-get install -y \
    zip\
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && docker-php-ext-install pdo  pgsql pdo_pgsql


EXPOSE 8080

RUN adduser www \
    && usermod -aG www www


RUN composer install \
    && chmod u+x /projet/entrypoint.sh \
    && php artisan key:gen

RUN chown -R www:www /projet \
    && chmod -R 775 /projet/storage


USER www

# Lancer le serveur Laravel
#ENTRYPOINT ["php","artisan", "serve"]
#ENTRYPOINT ["sleep 10000000000000000000000"]

ENTRYPOINT ["php", "artisan", "serve", "--host", "0.0.0.0"]


