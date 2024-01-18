#!/bin/bash

# LDAP Server information
URL="${LDAP_URL}"
BASE_DN="${LDAP_USERS_DN},${LDAP_BASE_DN}"
BINDDN="${LDAP_BindDN},${LDAP_BASE_DN}"
BINDPW="${LDAP_BindPassword}"

# Username used for logging in.
# Exp: username@ssh.insat.tn
username="$1"

# Temp files used while converting OpenSSL
# certificate to an OpenSSH public key format.
CERT_FILE=$(mktemp) # x509 OpenSSL File
PUB_PEM_FILE=$(mktemp) # Extract public key (PEM)
PUB_SSH_FILE=$(mktemp) # Converted OpenSSH Format file

# Logging
echo "Looking up $username certificate" >&2

# X509 Certificate
echo "-----BEGIN CERTIFICATE-----" > $CERT_FILE

# Specify path for CA & user's certificate/private key.
export LDAPTLS_CACERT=/certs/cert-ca.pem
export LDAPTLS_CERT=/certs/cert-user.pem
export LDAPTLS_KEY=/certs/priv-user.pem

# Fetch certificate from user attribute "usercertificate".
ldapsearch -x -H "$URL" \
  -D "$BINDDN" \
  -w "$BINDPW" \
  -b "$BASE_DN" \
  "(&(objectClass=posixAccount)(uid=$username))" usercertificate \
  | grep -o -zP '(?s)(?<=userCertificate;binary:: ).*(?=# search)' \
  | sed 's/ //g' | sed 's/\x0//g' | sed -r '/^\s*$/d' >> $CERT_FILE

echo "-----END CERTIFICATE-----" >> $CERT_FILE

# Extract public key
openssl x509 -in $CERT_FILE -noout -pubkey > $PUB_PEM_FILE

# Convert public key to openssh format
ssh-keygen -f $PUB_PEM_FILE -i -m PKCS8 > $PUB_SSH_FILE

cat $PUB_SSH_FILE
