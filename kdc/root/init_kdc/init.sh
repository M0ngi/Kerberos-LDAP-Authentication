#!/bin/bash

echo "Creating pricipals..."

cat /init_kdc/principals | while read line
do
  username=$(echo $line | cut -d : -f 1)
  password=$(echo $line | cut -d : -f 2)

  kadmin.local -q "addprinc -pw \"$password\" $username"
done

kadmin.local -q "listprincs"

/init_kdc/init_ktabs.sh
