#!/bin/bash

# Fix PHP FPM Env Vars and sock location
for f in /etc/php/*/fpm/pool.d/www.conf
do
  sed -i 's/^;clear_env = no$/clear_env = no/; s/^listen =.*$/listen = \/run\/php\/php-fpm\.sock/' $f
done

# Fix permissions
chown www-data:www-data -R /var/www/html

# Initilize DB
sudo -Eu www-data php /var/www/html/update.php --update-schema=force-yes

# Run PHP FPM
echo "Starting PHP"
for f in /usr/sbin/php-fpm*
do
  $f
done

# Run Ngnix
echo "Starting Nginx"
/usr/sbin/nginx -g "daemon off;"