#!/bin/bash

PIDFILE=/var/run/influxdb.pid

if [ "X${INFLUXDB_CLUSTER_PEERS}" != "X" ];then
 	INFLUXD_JOIN="-join ${INFLUXDB_CLUSTER_PEERS}"
fi
if [ "X${INFLUXDB_HOSTNAME}" != "X" ];then
    INFLUXD_HOST="${INFLUXDB_HOSTNAME}"
else
    INFLUXD_HOST="$(hostname -f)"
fi
INFLUXD_OPTS="-hostname ${INFLUXD_HOST}:8088 ${INFLUXD_JOIN}"

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

influxd -pidfile ${PIDFILE} -config /etc/influxdb/influxdb.conf ${INFLUXD_OPTS} &
sleep 3
#curl -sG http://localhost:8086/query --data-urlencode "q=CREATE DATABASE carbon"
#curl -sG http://localhost:8086/query --data-urlencode "q=CREATE DATABASE influxdb"

while [ -f ${PIDFILE} ];do
    sleep 1
done
