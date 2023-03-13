#!/bin/bash

if [ ! -d /run/php/ ]; then
  mkdir /run/php/
fi

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp core download --allow-root

echo "Wordpress is Running.."
chown -R www-data:www-data /var/www/html/wordpress
mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wordpress/wp-config.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wordpress/wp-config.php
sed -i "85i define('WP_REDIS_PORT', 6379);" /var/www/html/wordpress/wp-config.php
sed -i "86i define('WP_REDIS_HOST', 'redis');" /var/www/html/wordpress/wp-config.php
echo "************" $IP_WP "*************"
wp core install --title="Inception" --url="http://$IP_WP" --admin_user=$WORDPRESS_ROOT_USER --admin_password=$WORDPRESS_ROOT_PASSWORD --admin_email="mmounchi@student.1337.ma" --allow-root
wp user create $WORDPRESS_USER "misaki@gmail.com" --user_pass=$WORDPRESS_PASSWORD --role=author --allow-root
echo "---------"
wp post list --format=ids --allow-root
echo "---------"


wp post create --post_title='My DNS Name' --post_content="$IP_WP" --post_type=page --post_status=publish --allow-root
# wp post create --post_title="My Server$Server" --post_content="*** $Server ***" --post_type=page --post_status=publish --allow-root

# wp post update 1 --post_title='My Ip Address' --post_content="$IP_WP" --post_type=page --allow-root
# --url="http://mmounchi.42.fr"
# --url="http://34.243.227.210"
# wp option update siteurl http://mmounchi.42.fr
# wp option update home http://mmounchi.42.fr
wp plugin install redis-cache --activate --allow-root
wp redis enable --force --allow-root

echo "Wordpress is Running.."

/usr/sbin/php-fpm7.3 -F -R