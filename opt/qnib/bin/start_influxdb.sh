#!/bin/bash

PIDFILE=/var/run/influxdb.pid

## Check if eth0 already exists
ADDR=eth0
ip addr show ${ADDR} > /dev/null
EC=$?
if [ ${EC} -eq 1 ];then
    echo "## Wait for pipework to attach device 'eth0'"
    pipework --wait
fi

trap "kill -9 $(cat ${PIDFILE})" SIGINT SIGTERM


/usr/bin/influxdb -pidfile ${PIDFILE} -config /opt/influxdb/current/config.toml &
sleep 3
/opt/qnib/bin/bootstrap_influxdb.sh

while [ -f ${PIDFILE} ];do
    sleep 1
done
