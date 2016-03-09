#!/usr/local/bin/dumb-init /bin/bash

PIDFILE=/var/run/influxdb.pid

if [ "X${INFLUXDB_CLUSTER_PEERS}" != "X" ];then
 	INFLUXD_JOIN="-join ${INFLUXDB_CLUSTER_PEERS}"
fi

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

influxd -pidfile ${PIDFILE} -config /etc/influxdb/influxdb.conf ${INFLUXD_OPTS} 
