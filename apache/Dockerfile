FROM php:7.2-apache@sha256:4dc0f0115acf8c2f0df69295ae822e49f5ad5fe849725847f15aa0e5802b55f8

COPY root/ /
RUN chown -R www-data:www-data /certs
RUN chmod -R 400 /certs
RUN chmod 500 /certs

RUN a2enmod ldap authnz_ldap ssl
