#!/bin/bash
composer install
php artisan key:generate
php artisan migrate
php artisan serv --host 0.0.0.0
