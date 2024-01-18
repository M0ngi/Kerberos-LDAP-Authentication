#!/bin/bash

# ldapwhoami -H ldap://ldap.insat.tn:389 -D "uid=teacher1,ou=users,dc=ldap,dc=insat,dc=tn" -w teacher_password

# TLS
ldapwhoami -H ldaps://ldap.insat.tn:636 -D "uid=teacher1,ou=users,dc=ldap,dc=insat,dc=tn" -w teacher_password
