# Documentation

## Resources

* [OpenLDAP](https://medium.com/rahasak/deploy-ldap-directory-service-with-openldap-docker-8d9f438f1216)
* [Adding Users/Groups in OpenLDAP](https://www.thegeekstuff.com/2015/02/openldap-add-users-groups/)
* [OpenLDAP Docker Image & Documentation](https://github.com/osixia/docker-openldap/)
* [OpenLDAP Doc](https://www.openldap.org/pub/ksoper/OpenLDAP_TLS_obsolete.html#4.3)
* [Apache mod_ldap](https://httpd.apache.org/docs/2.2/mod/mod_ldap.html)
* [Apache mod_authnz_ldap](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html)
* [Apache + LDAP Docker image](https://github.com/zhonger/docker-ldap-apache/tree/main)
* [OpenVPN Setup in Ubuntu](https://ubuntu.com/server/docs/service-openvpn)
* [OpenVPN + LDAP](https://medium.com/@hiranadikari993/openvpn-active-directory-authentication-726f3bac3546)
* [openvpn-auth-ldap Documentation](https://github.com/threerings/openvpn-auth-ldap)
* [Bind9 DNS](https://mpolinowski.github.io/docs/DevOps/Provisioning/2022-01-25--installing-bind9-docker/2022-01-25/)
* [SSH With Kerberos Authentication](https://cwiki.apache.org/confluence/display/DIRxINTEROP/Kerberos+Authentication+to+SSHD)

## Environment Setup

### Docker:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
```

### Docker-compose

To install `docker-compose` plugin:

```bash
sudo apt-get install docker-compose-plugin
```

or use `docker compose` instead.

### LDAP utils

If you want to query the LDAP server directly from your host machine, you'll need to install ldap utils

```bash
sudo apt install ldap-utils
```

### Folder architecture

#### Services:

* [ldap](./ldap/): **ldap** service image & configuration. Based on osixia/openldap image.
* [ssh](./ssh/): **ssh** service image & configuration. Based on ubuntu image. Uses Kerberos & LDAP Authentication.
* [apache](./apache/): **web** service image & configuration. Based on php-apache image. Uses LDAP Authentication for route `/secure`.
* [openvpn](./openvpn/): **openvpn** service image & configuration. Based on ubuntu image. Uses LDAP Authentication.
* [dns](./dns/): **dns** service image & configuration. Based on internetsystemsconsortium/bind9 image.
* [kdc](./kdc/): **kdc** service image & configuration. Kerberos's KDC Server.

#### Clients:

* [client](./client/): **client** service, used to test Kerberos authentication.
* [teacher1](./teacher1/): **teacher1** service, used to test LDAP, DNS & SSH with LDAP credentials.
* [student1](./student1/): **student1** service, used to test LDAP, DNS & SSH with LDAP credentials (Should be blocked access).

### Setup

Running [/setup.sh](./setup.sh) should:
* Initialize hosts file by running [/setup_hosts.sh](./setup_hosts.sh).
* Initialize docker network, to be used by all services, by running [/setup_network.sh](./setup_network.sh).
* Create certificates & update configuration by running [/setup_pki.sh](./setup_pki.sh)

For testing, we have 3 services representing 3 different client environments:
* Teacher1: To open environment, run [/teacher1.sh](./teacher1.sh)
* Student1: To open environment, run [/student1.sh](./student1.sh)
* Client: Used for Kerberos authentication, to open environment run [/client.sh](./client.sh)

## Public Key Infrastructure (PKI)

[/setup_pki.sh](./setup_pki.sh) handles the creation of certificates & updating the required configuration folders (to provide certificates/key).

First, it'll generate a self-signed CA certificate:

```bash
openssl req -x509 -nodes \
  -days 100000 -newkey rsa:2048 \
  -addext "keyUsage = cRLSign, keyCertSign" \
  -addext "basicConstraints = CA:TRUE" \
  -keyout ./certs/ca/priv-ca.pem \
  -out ./certs/ca/cert-ca.pem \
  -subj "/C=TN/ST=Tunis/L=Centre Urbain/O=CA/OU=IT/CN=www.ca.tn/emailAddress=contact@ca.tn"
```

Then it'll generate for each service (including clients) a certificate sign request, which will be signed by the CA:

```bash
# Certificate Request
openssl req -nodes \
  -newkey rsa:2048 \
  -addext "extendedKeyUsage = serverAuth" \
  -addext "keyUsage = digitalSignature,keyEncipherment" \
  -keyout ./certs/openvpn_server/priv-openvpn.pem \
  -out ./certs/openvpn_server/cert-openvpn.csr \
  -subj "/C=TN/ST=Tunis/L=Centre Urbain/O=OpenVPNServer/OU=Education/CN=insat.tn/emailAddress=contact@insat.tn"

# Sign & generate certificate
openssl x509 -req \
  -in ./certs/openvpn_server/cert-openvpn.csr \
  -CA ./certs/ca/cert-ca.pem \
  -CAkey ./certs/ca/priv-ca.pem \
  -CAcreateserial -CAserial serial.ca \
  -out ./certs/openvpn_server/cert-openvpn.pem \
  -days 365 \
  -copy_extensions=copyall
```

To view a certificate:

```bash
openssl x509 -in cert-ca.pem -text -noout # View cert
```

To view a certificate used by a host:

```bash
openssl s_client -connect insat.tn:636 -showcerts
```

The server forces client certificate check, therefore, you must use a certificate signed by the server's CA.

Configure your ldap client by adding this to your `/etc/ldap.conf`:

````text
TLS_REQCERT try
TLS_CACERT      /mnt/c/Users/saida/OneDrive/Documents/Github/Projet-Kerberos-GL4/ldap/certs/cert-ca.pem
TLS_CERT        /mnt/c/Users/saida/OneDrive/Documents/Github/Projet-Kerberos-GL4/ldap/user/cert-c1.pem
TLS_KEY         /mnt/c/Users/saida/OneDrive/Documents/Github/Projet-Kerberos-GL4/ldap/user/key-c1.pem
```

OR you can simply open a shell in [/ldap/user](./ldap/user/) directory. LDAP will automatically use `ldaprc` as a configuration file.
