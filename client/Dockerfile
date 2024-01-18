FROM ubuntu:latest@sha256:6042500cf4b44023ea1894effe7890666b0c5c7871ed83a97c36c76ae560bb9b

RUN apt-get update

RUN apt-get install -y \
  # for  envsubst
  gettext-base \
  # Kerberos
  krb5-config krb5-user \
  ssh

COPY root/ /

RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
