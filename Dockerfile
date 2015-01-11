FROM qnib/terminal
MAINTAINER "Christian Kniep <christian@qnib.org>"

RUN rpm -ivh http://s3.amazonaws.com/influxdb/influxdb-latest-1.x86_64.rpm
ADD etc/supervisord.d/influxdb.ini /etc/supervisord.d/influxdb.ini

EXPOSE 8086
