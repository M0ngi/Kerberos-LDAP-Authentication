#!/bin/bash

parseFile() {
  local filePath="$1"

  # Check if the file exists
  if [ ! -f "$filePath" ]; then
    echo "Error: File not found - $filePath"
    return 1
  fi

  tmp_file=$(mktemp)

  envsubst "$(env | cut -d = -f 1 | sed 's/\(.*\)/${\1}/' | tr '\n' ' ')" < "$filePath" > "$tmp_file"
  chmod --reference="$filePath" "$tmp_file"

  mv "$tmp_file" "$filePath"
}

parseFile "/home/user/ldaprc"
parseFile "/etc/ldap.conf"
parseFile "/etc/ldap/ldap.conf"
parseFile "/etc/ssh/sshd_config"
parseFile "/etc/krb5.conf"
parseFile "/ldap_lookup.sh"

/usr/sbin/sshd -D -e
