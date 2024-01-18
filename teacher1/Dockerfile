FROM ubuntu:latest@sha256:6042500cf4b44023ea1894effe7890666b0c5c7871ed83a97c36c76ae560bb9b

RUN apt update && apt install -y \
  ldap-utils \
  ssh \
  dnsutils

RUN useradd -d /home/user/ -m -p user -s /bin/bash user

COPY root/ /

RUN chown user:user /certs -R
RUN chmod 500 /certs -R

RUN chmod +x /home/user/*.sh

RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
