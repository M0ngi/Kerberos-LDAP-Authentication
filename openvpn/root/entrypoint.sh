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

# Parse configuration
parseFile "/etc/openvpn/server/server.conf"
parseFile "/etc/openvpn/auth/ldap-auth.conf"

# Generate DH params
openssl dhparam -out /certs/dh.pem 2048
echo "DH generated."

# Create TUN device
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
  echo "$(datef) Creating tun/tap device."
  mknod /dev/net/tun c 10 200
  chmod 600 /dev/net/tun
fi

# Enable IP Forwarding
sed '/net.ipv4.ip_forward=1/s/^# *//' -i /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

# Run OpenVPN with the provided configuration
openvpn --config /etc/openvpn/server/server.conf

