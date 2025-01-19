#!/bin/sh

# Prepare directories and permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# Adjust R/W permissions and edit configuration
chmod 644 /etc/my.cnf
sed -i "s|skip-networking|skip-networking=0|g" /etc/my.cnf

# Initialize database if necessary
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB with bootstrap
mysqld --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Start MariaDB server
exec mysqld --user=mysql
