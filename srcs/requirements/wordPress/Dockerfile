FROM alpine:3.19

RUN apk add --no-cache  php \
                        php-phar \
                        php-fpm \
                        php-iconv \
                        php-mysqli \
                        curl \
                        bash

COPY ./config/wp-setup.sh ./wp-setup.sh
RUN chmod +x ./wp-setup.sh

EXPOSE 9000

CMD [ "./wp-setup.sh" ]
