#!/bin/bash
apt update -yq && apt upgrade -yq
monero-gen-ssl-cert --certificate-filename=/ssl/rpc_ssl.crt --private-key-filename=/ssl/rpc_ssl.key
chown www-data:www-data /ssl/rpc_ssl.key
chown www-data:www-data /ssl/rpc_ssl.crt
exec supervisord -c /config/supervisord.conf -n
