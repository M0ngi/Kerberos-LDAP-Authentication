FROM ubuntu:latest@sha256:6042500cf4b44023ea1894effe7890666b0c5c7871ed83a97c36c76ae560bb9b

RUN apt update && \
  apt-get install krb5-kdc krb5-admin-server krb5-config -y

RUN apt install -y \
  ssh \
  # for  envsubst
  gettext-base

RUN mkdir -pv /var/log/kerberos/
RUN touch /var/log/kerberos/krb5.log
RUN touch /var/log/kerberos/kadmin.log
RUN touch /var/log/kerberos/krb5lib.log

COPY root/ /

RUN chmod +x /init_kdc/*.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
