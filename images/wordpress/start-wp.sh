#!/bin/bash

/etc/init.d/mysql start
sleep 10
mysql -u root -pjuniper2019 -e "CREATE DATABASE wordpress_db;"
mysql -u root -pjuniper2019 -e "GRANT ALL PRIVILEGES ON wordpress_db.* TO 'root'@'localhost' IDENTIFIED BY 'juniper2019';"
mysql -u root -pjuniper2019 -e "FLUSH PRIVILEGES;"

# https://indigotree.co.uk/automated-wordpress-installation-with-bash-wp-cli/
cd /var/www/html

wp --allow-root db create
wp --allow-root core install \
    --url="http://localhost:8080/" \
    --title="Hackathon2019" \
    --admin_user="wordpress" \
    --admin_password="Wordpress@2019" \
    --admin_email="wordpress@lab.local"

/usr/sbin/apache2ctl -DFOREGROUND
