#!/bin/bash

echo "Creating ktabs..."

kadmin.local -q "ktadd -k /etc/krb5kdc/kadm5.keytab host/ssh.insat.tn@INSAT.TN"
cp /etc/krb5kdc/kadm5.keytab /etc/krb5.keytab

sleep 60 # Wait for LDAP server to be up

scp -o "StrictHostKeyChecking no" -P 2222 -i /certs/priv-kdc.pem /etc/krb5.keytab kdc@ssh.insat.tn:.
ssh -o "StrictHostKeyChecking no" -p 2222 -i /certs/priv-kdc.pem kdc@ssh.insat.tn -t '/update_ktab'

echo "Updated keytab file on SSH Service"
