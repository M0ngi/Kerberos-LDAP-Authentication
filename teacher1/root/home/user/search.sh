#!/bin/bash

# TLS
ldapsearch -H ldaps://ldap.insat.tn:636 \
  -D "uid=teacher1,ou=users,dc=ldap,dc=insat,dc=tn" \
  -w teacher_password \
  -b "uid=teacher1,ou=users,dc=ldap,dc=insat,dc=tn"

# ldapsearch -H ldap://ldap.insat.tn:389 \
# -D "uid=teacher1,ou=users,dc=ldap,dc=insat,dc=tn" \
# -w teacher_password \
# -b "uid=teacher1,ou=users,dc=ldap,dc=insat,dc=tn"
