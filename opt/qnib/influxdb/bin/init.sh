#!/usr/local/bin/dumb-init /bin/bash

set -ex

source /opt/qnib/consul/etc/bash_functions.sh

wait_for_srv influxdb

## Create databases
for db in $(echo ${INFLUXDB_DATABASES} |sed -e 's/,/ /g');do
    influx -host localhost -password root -username root -execute "CREATE DATABASE ${db}"
done

sleep 5
exit 0
