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

function stop_influxdb {
    kill -9 $(cat ${PIDFILE})
    exit
}
trap "stop_influxdb" SIGINT SIGTERM


/opt/influxdb/influxd -pidfile ${PIDFILE} -config /opt/influxdb/current/config.toml &
sleep 3
curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE carbon"
curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE influxdb"

while [ -f ${PIDFILE} ];do
    sleep 1
done
