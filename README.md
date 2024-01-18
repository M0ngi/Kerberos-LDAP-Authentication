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

## Setup

* Domain:

Add the following line to your `/etc/hosts` file

```text
0.0.0.0         insat.tn
```

* Docker

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
```

* LDAP Tools:

```bash
sudo apt install ldap-utils
```

* LDAP Certificate:

```bash
# CA
openssl req -x509 -nodes -days 100000 -newkey rsa:2048 -keyout priv-ca.pem -out cert-ca.pem # Gen priv & cert
openssl x509 -in cert-ca.pem -text -noout # View cert

# LDAP Server
openssl req -nodes -newkey rsa:2048 -keyout priv-srv.pem -out cert-srv.csr # Certificate Request
openssl x509 -req -in cert-srv.csr -CA cert-ca.pem -CAkey priv-ca.pem -CAcreateserial -CAserial serial.ca -out cert-srv.pem -days 365 # Sign & generate certificate

# Verify Certificates:
openssl s_client -connect insat.tn:636 -showcerts

# Client 1
openssl req -nodes -newkey rsa:2048 -keyout key-c1.pem -out cert-c1.csr # Certificate Request
openssl x509 -req -in cert-c1.csr -CA cert-ca.pem -CAkey priv-ca.pem -CAcreateserial -CAserial serial.ca -out cert-c1.pem -days 365
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
