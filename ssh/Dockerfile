FROM ubuntu:latest@sha256:6042500cf4b44023ea1894effe7890666b0c5c7871ed83a97c36c76ae560bb9b

# Update the system
RUN apt-get update

# Install OpenSSH Server
RUN apt-get install -y \
  openssh-server \
  libpam-ldap libnss-ldap ldap-utils \
  # for  envsubst
  gettext-base

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install --no-install-recommends -y ntp

# Set up configuration for SSH
RUN mkdir /var/run/sshd
RUN useradd -d /home/user/ -m -p user -s /bin/bash user
RUN echo "user:user" | chpasswd

COPY root/ /
RUN chown -R user:user /certs
RUN chmod -R 400 /certs
RUN chmod 700 /certs

ENV LDAPCONF=/etc/ldap.conf
RUN chown root:10002 /update_ktab
RUN chmod +s /update_ktab
RUN chmod +x /*.sh
CMD ["/entrypoint.sh"]
