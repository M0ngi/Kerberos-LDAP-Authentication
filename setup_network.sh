#!/bin/bash

sudo docker network create \
  --driver=bridge \
  --subnet="172.50.0.0/24" \
  --gateway="172.50.0.1" "insat.tn"
