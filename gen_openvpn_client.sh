#!/bin/bash

if [[ $# != 3 ]] ; then
  printf "Missing parameters\n";
  printf "Usage: $0 [CA Path] [Client Cert Path] [Client Key Path]\n";
  exit 1;
fi

HOST_ADDR=localhost
PORT=1194
CLIENT_PATH=client.ovpn
CA=$1
CL_CRT=$2
CL_KEY=$3

cp client.ovpn.template "$CLIENT_PATH"

echo -e "\nremote $HOST_ADDR $PORT" >> "$CLIENT_PATH"

cat <(echo -e '<ca>') \
  "$CA" <(echo -e '</ca>\n<cert>') \
  "$CL_CRT" <(echo -e '</cert>\n<key>') \
  "$CL_KEY" <(echo -e '</key>') \
  >> "$CLIENT_PATH"

echo "Out: $CLIENT_PATH"
