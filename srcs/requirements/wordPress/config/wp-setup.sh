#!/bin/bash

# Wait until the MariaDB service is reachable on port 3306
until nc -z -w5 mariadb 3306; do
    echo "Waiting for MariaDB to start..."
    sleep 5
done
echo "MariaDB pinged Successfully."

# Exit immediately if any command exits with a non-zero status
set -e


# Create the WordPress installation directory if it doesn't exist
mkdir -p /var/www/html
cd /var/www/html

# Remove any existing files in the WordPress directory to start fresh
rm -rf *

# Download the WP-CLI tool (WordPress Command Line Interface)
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Make the WP-CLI binary executable
chmod +x wp-cli.phar

# Move the WP-CLI binary to a directory in the PATH for global access
mv wp-cli.phar /usr/local/bin/wp

# Download the core WordPress files
wp core download --allow-root

# Create the WordPress configuration file using environment variables
wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --skip-check --allow-root

# Install WordPress with the provided credentials and site details
wp core install --url=$DOMAIN_NAME --title="Inception" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root

# Grant full read, write, and execute permissions to the WordPress directory
chmod -R 777 /var/www/html/

# Check if the additional user already exists in WordPress
# If not, create the user with the specified credentials
if ! wp user get $WP_USER --field=ID --allow-root >/dev/null 2>&1; then
    wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --allow-root
fi

# Update the PHP-FPM configuration to set the listening port to 9000
sed -i 's|listen = .*|listen = 9000|' /etc/php82/php-fpm.d/www.conf
echo "Updated php port"

# Create the directory for PHP runtime files
mkdir -p /run/php

# Ensure the WordPress directory has proper permissions
chmod -R 777 /var/www/html/

# Start the PHP FastCGI Process Manager in the foreground
echo "Running php-fpm"
php-fpm82 -F

echo "Done"

