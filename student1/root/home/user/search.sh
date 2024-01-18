#!/bin/bash

# TLS
ldapsearch -H ldaps://ldap.insat.tn:636 \
  -D "uid=student1,ou=users,dc=ldap,dc=insat,dc=tn" \
  -w student_password \
  -b "uid=student1,ou=users,dc=ldap,dc=insat,dc=tn"

# ldapsearch -H ldap://ldap.insat.tn:389 \
# -D "uid=student1,ou=users,dc=ldap,dc=insat,dc=tn" \
# -w student_password \
# -b "uid=student1,ou=users,dc=ldap,dc=insat,dc=tn"
