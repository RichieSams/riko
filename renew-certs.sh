#!/bin/bash

certbot certonly --non-interactive --agree-tos \
    --email adastley@gmail.com --preferred-challenges dns \
    --authenticator dns-porkbun --dns-porkbun-credentials /conf/porkbun.ini --dns-porkbun-propagation-seconds 60 \
    --renew-hook "/bin/bash /reload-haproxy.sh jellyfin.astleymanor.net" \
    -d "jellyfin.astleymanor.net"

certbot certonly --non-interactive --agree-tos \
    --email adastley@gmail.com --preferred-challenges dns \
    --authenticator dns-porkbun --dns-porkbun-credentials /conf/porkbun.ini --dns-porkbun-propagation-seconds 60 \
    --renew-hook "/bin/bash /reload-haproxy.sh grafana.astleymanor.net" \
    -d "grafana.astleymanor.net"

certbot certonly --non-interactive --agree-tos \
    --email adastley@gmail.com --preferred-challenges dns \
    --authenticator dns-porkbun --dns-porkbun-credentials /conf/porkbun.ini --dns-porkbun-propagation-seconds 60 \
    --renew-hook "/bin/bash /reload-haproxy.sh alertmanager.astleymanor.net" \
    -d "alertmanager.astleymanor.net"

certbot certonly --non-interactive --agree-tos \
    --email adastley@gmail.com --preferred-challenges dns \
    --authenticator dns-porkbun --dns-porkbun-credentials /conf/porkbun.ini --dns-porkbun-propagation-seconds 60 \
    --renew-hook "/bin/bash /reload-haproxy.sh vmagent.astleymanor.net" \
    -d "vmagent.astleymanor.net"
