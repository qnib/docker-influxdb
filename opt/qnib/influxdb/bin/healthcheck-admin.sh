#!/usr/local/bin/dumb-init /bin/bash

echoerr() { echo "$@" 1>&2; }

echo "> curl -sI 127.0.0.1:8083 |head -n1 |grep 200"
curl -sI 127.0.0.1:8083 |head -n1 |grep 200
EC=$?
if [ ${EC} -ne 0 ];then
    echoerr "> curl -sI 127.0.0.1:8083 |head -n1 |grep 200"
    exit ${EC}
else
    exit 0
fi
