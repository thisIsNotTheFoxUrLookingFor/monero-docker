#!/bin/bash
exec sudo -H -u www-data monerod --non-interactive=1 --config-file=/config/monerod.conf
