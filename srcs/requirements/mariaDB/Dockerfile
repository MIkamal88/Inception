FROM alpine:3.19

# Install Mariadb
RUN apk add --no-cache mariadb mariadb-client

# Copy configuration to Container and give execution permission to setup script
COPY ./config/my_config.conf /etc/my.cnf
COPY ./config/db_setup.sh ./db_setup.sh
RUN chmod +x ./db_setup.sh

EXPOSE 3306

CMD ["./db_setup.sh"]

# mysql -u${username} -p && SHOW DATABASES; && SHOW TABLES;
