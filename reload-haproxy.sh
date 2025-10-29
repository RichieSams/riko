#!/bin/bash

domain_name=$1

# Copy the new live certs over
cat /etc/letsencrypt/live/${domain_name}/fullchain.pem /etc/letsencrypt/live/${domain_name}/privkey.pem | sed '/^$/d' > /certs/${domain_name}.pem

# Reload haproxy via docker
curl --silent -X POST --unix-socket /var/run/docker.sock "http://localhost/containers/haproxy/kill?signal=SIGHUP"
