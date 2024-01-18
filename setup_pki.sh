#!/bin/bash

./cleanup_pki.sh

# CA Certificate
echo "Generating CA Certificate"

openssl req -x509 -nodes \
  -days 100000 -newkey rsa:2048 \
  -addext "keyUsage = cRLSign, keyCertSign" \
  -addext "basicConstraints = CA:TRUE" \
  -keyout ./certs/ca/priv-ca.pem \
  -out ./certs/ca/cert-ca.pem \
  -subj "/C=TN/ST=Tunis/L=Centre Urbain/O=CA/OU=IT/CN=www.ca.tn/emailAddress=contact@ca.tn"

# LDAP Server Certificate
echo "Generating LDAP Server certificate"

# Certificate Request
openssl req -nodes \
  -newkey rsa:2048 \
  -keyout ./certs/ldap/priv-srv.pem \
  -out ./certs/ldap/cert-srv.csr \
  -subj "/C=TN/ST=Tunis/L=Centre Urbain/O=INSAT/OU=Education/CN=ldap.insat.tn/emailAddress=insat@ca.tn"

# Sign & generate certificate
openssl x509 -req \
  -in ./certs/ldap/cert-srv.csr \
  -CA ./certs/ca/cert-ca.pem \
  -CAkey ./certs/ca/priv-ca.pem \
  -CAcreateserial -CAserial serial.ca \
  -out ./certs/ldap/cert-srv.pem \
  -days 365

# Student1 Certificate
echo "Generating Student1 certificate"

# Certificate Request
openssl req -nodes \
  -newkey rsa:2048 \
  -keyout ./certs/student1/priv-student1.pem \
  -out ./certs/student1/cert-student1.csr \
  -subj "/C=TN/ST=Tunis/L=Centre Urbain/O=Student1/OU=Education/CN=insat.tn/emailAddress=student1@insat.tn"

# Sign & generate certificate
openssl x509 -req \
  -in ./certs/student1/cert-student1.csr \
  -CA ./certs/ca/cert-ca.pem \
  -CAkey ./certs/ca/priv-ca.pem \
  -CAcreateserial -CAserial serial.ca \
  -out ./certs/student1/cert-student1.pem \
  -days 365

# Teacher1 Certificate
echo "Generating Teacher1 certificate"

# Certificate Request
openssl req -nodes \
  -newkey rsa:2048 \
  -keyout ./certs/teacher1/priv-teacher1.pem \
  -addext "extendedKeyUsage = clientAuth" \
  -addext "keyUsage = digitalSignature" \
  -out ./certs/teacher1/cert-teacher1.csr \
  -subj "/C=TN/ST=Tunis/L=Centre Urbain/O=Teacher1/OU=Education/CN=insat.tn/emailAddress=teacher1@insat.tn"

# Sign & generate certificate
openssl x509 -req \
  -in ./certs/teacher1/cert-teacher1.csr \
  -CA ./certs/ca/cert-ca.pem \
  -CAkey ./certs/ca/priv-ca.pem \
  -CAcreateserial -CAserial serial.ca \
  -out ./certs/teacher1/cert-teacher1.pem \
  -copy_extensions=copyall \
  -days 365

# KDC Certificate
echo "Generating KDC certificate"

# Certificate Request
openssl req -nodes \
  -newkey rsa:2048 \
  -keyout ./certs/kdc/priv-kdc.pem \
  -addext "extendedKeyUsage = clientAuth" \
  -addext "keyUsage = digitalSignature" \
  -out ./certs/kdc/cert-kdc.csr \
  -subj "/C=TN/ST=Tunis/L=Centre Urbain/O=Kdc/OU=Education/CN=insat.tn/emailAddress=contact@insat.tn"

# Sign & generate certificate
openssl x509 -req \
  -in ./certs/kdc/cert-kdc.csr \
  -CA ./certs/ca/cert-ca.pem \
  -CAkey ./certs/ca/priv-ca.pem \
  -CAcreateserial -CAserial serial.ca \
  -out ./certs/kdc/cert-kdc.pem \
  -copy_extensions=copyall \
  -days 365

# SSH user Certificate
echo "Generating SSH user certificate"

# Certificate Request
openssl req -nodes \
  -newkey rsa:2048 \
  -keyout ./certs/ssh_user/priv-user.pem \
  -out ./certs/ssh_user/cert-user.csr \
  -subj "/C=TN/ST=Tunis/L=Centre Urbain/O=SSHUser/OU=Education/CN=insat.tn/emailAddress=contact@insat.tn"

# Sign & generate certificate
openssl x509 -req \
  -in ./certs/ssh_user/cert-user.csr \
  -CA ./certs/ca/cert-ca.pem \
  -CAkey ./certs/ca/priv-ca.pem \
  -CAcreateserial -CAserial serial.ca \
  -out ./certs/ssh_user/cert-user.pem \
  -days 365

# Apache user Certificate
echo "Generating apache user certificate"

# Certificate Request
openssl req -nodes \
  -newkey rsa:2048 \
  -keyout ./certs/apache_user/priv-apache.pem \
  -out ./certs/apache_user/cert-apache.csr \
  -subj "/C=TN/ST=Tunis/L=Centre Urbain/O=ApacheUser/OU=Education/CN=insat.tn/emailAddress=contact@insat.tn"

# Sign & generate certificate
openssl x509 -req \
  -in ./certs/apache_user/cert-apache.csr \
  -CA ./certs/ca/cert-ca.pem \
  -CAkey ./certs/ca/priv-ca.pem \
  -CAcreateserial -CAserial serial.ca \
  -out ./certs/apache_user/cert-apache.pem \
  -days 365

# OpenVPN Server Certificate
echo "Generating OpenVPN Server certificate"

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

# Move files to required paths

# LDAP Config
cp ./certs/ldap/cert-srv.pem ./ldap/certs/
cp ./certs/ldap/priv-srv.pem ./ldap/certs/
cp ./certs/ca/cert-ca.pem ./ldap/certs/

# SSH User Certificate
cp ./certs/ca/cert-ca.pem ./ssh/root/certs/
cp ./certs/ssh_user/cert-user.pem ./ssh/root/certs/
cp ./certs/ssh_user/priv-user.pem ./ssh/root/certs/

# Apache User Certificate
cp ./certs/ca/cert-ca.pem ./apache/root/certs/
cp ./certs/apache_user/cert-apache.pem ./apache/root/certs/
cp ./certs/apache_user/priv-apache.pem ./apache/root/certs/

# KDC Certificate
cp ./certs/ca/cert-ca.pem ./kdc/root/certs/
cp ./certs/kdc/cert-kdc.pem ./kdc/root/certs/
cp ./certs/kdc/priv-kdc.pem ./kdc/root/certs/

# Apache User Certificate
cp ./certs/ca/cert-ca.pem ./openvpn/root/certs/
cp ./certs/openvpn_server/cert-openvpn.pem ./openvpn/root/certs/
cp ./certs/openvpn_server/priv-openvpn.pem ./openvpn/root/certs/

# LDAP ldif file
cp ./ldap/ldif/2-init-users.ldif.template ./ldap/ldif/2-init-users.ldif

echo "usercertificate;binary:: $(cat ./certs/student1/cert-student1.pem | sed '1,1d; $d' | awk 'NR>1 {$0 = " " $0} 1')" > tmp_row
sed -e '/STUDENT_CERT_TEMPLATE/{' -e 'r tmp_row' -e 'd' -e '}' -i ./ldap/ldif/2-init-users.ldif

echo "usercertificate;binary:: $(cat ./certs/teacher1/cert-teacher1.pem | sed '1,1d; $d' | awk 'NR>1 {$0 = " " $0} 1')" > tmp_row
sed -e '/TEACHER_CERT_TEMPLATE/{' -e 'r tmp_row' -e 'd' -e '}' -i ./ldap/ldif/2-init-users.ldif

echo "usercertificate;binary:: $(cat ./certs/kdc/cert-kdc.pem | sed '1,1d; $d' | awk 'NR>1 {$0 = " " $0} 1')" > tmp_row
sed -e '/KDC_CERT_TEMPLATE/{' -e 'r tmp_row' -e 'd' -e '}' -i ./ldap/ldif/2-init-users.ldif

rm tmp_row

# Student1 env
cp ./certs/ca/cert-ca.pem ./student1/root/certs/
cp ./certs/student1/cert-student1.pem ./student1/root/certs/
cp ./certs/student1/priv-student1.pem ./student1/root/certs/

# Teacher1 env
cp ./certs/ca/cert-ca.pem ./teacher1/root/certs/
cp ./certs/teacher1/cert-teacher1.pem ./teacher1/root/certs/
cp ./certs/teacher1/priv-teacher1.pem ./teacher1/root/certs/
