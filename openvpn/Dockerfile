FROM ubuntu:latest@sha256:6042500cf4b44023ea1894effe7890666b0c5c7871ed83a97c36c76ae560bb9b

RUN apt-get update
RUN apt install -y \
  openvpn easy-rsa \
  openvpn-auth-ldap \
  # for  envsubst
  gettext-base

COPY root/ /

RUN chmod -R 400 /certs
RUN chmod +x /certs
RUN chmod +x /usr/lib/openvpn/openvpn-auth-ldap.so

RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]


