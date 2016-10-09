#!/usr/local/bin/dumb-init /bin/bash

echoerr() { echo "$@" 1>&2; }


if [ $(influx -execute "SHOW databases" | grep -c _internal) -ne 1 ];then
    echoerr "> $(influx -execute \"SHOW databases\" | grep -c _internal) != 1 [FAIL]"
    echoerr "Database '_internal' not yet present..."
    exit 1
else
    echo "> $(influx -execute \"SHOW databases\" | grep -c _internal) == 1 [OK]"
    exit 0
fi
