#!/bin/bash

sudo ./setup_hosts.sh
sudo ./setup_network.sh
./setup_pki.sh

# Run all containers
sudo docker compose up
