FROM osixia/openldap:1.5.0

RUN rm /container/service/slapd/assets/certs/*

COPY ldif/ /container/service/slapd/assets/config/bootstrap/ldif/custom/
COPY certs/ /container/service/slapd/assets/certs/
