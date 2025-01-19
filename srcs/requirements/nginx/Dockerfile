FROM alpine:3.19

RUN apk update && apk add --no-cache nginx openssl

RUN mkdir /etc/nginx/ssl

# openssl
# req: Subcommand for creating and processing certificate requests.
# -x509: This option outputs a self-signed certificate instead of a certificate request.
# -nodes: If this option is specified then if a private key is created it will not be encrypted.
# -days: When the -x509 option is being used this specifies the number of days to certify the certificate for.
# -newkey: This option creates a new certificate request and a new private key.
# rsa:2048: This specifies the size of the private key to generate in bits.
# -keyout: This gives the filename to write the newly created private key to.
# -out: This specifies the filename to write the certificate to.
# -subj: This option sets the subject name to use.
RUN openssl req -x509 -newkey rsa:2048 -sha256 -days 365 -nodes \
    -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \
    -subj "/CN=mshehata.42.fr"

COPY ./config/nginx.conf /etc/nginx/http.d

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
