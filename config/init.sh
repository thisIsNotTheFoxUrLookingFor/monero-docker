#!/bin/bash
monero-gen-ssl-cert --certificate-filename=/monero/rpc_ssl.crt --private-key-filename=/monero/rpc_ssl.key
chown root:www-data /monero/rpc_ssl.key
chown root:www-data /monero/rpc_ssl.crt
exec sudo -H -u www-data monerod --non-interactive --config-file=/config/monerod.conf
