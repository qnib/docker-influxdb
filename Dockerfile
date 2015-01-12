FROM qnib/terminal
MAINTAINER "Christian Kniep <christian@qnib.org>"

RUN rpm -ivh http://s3.amazonaws.com/influxdb/influxdb-latest-1.x86_64.rpm
ADD etc/supervisord.d/influxdb.ini /etc/supervisord.d/influxdb.ini
ADD opt/qnib/bin/start_influxdb.sh /opt/qnib/bin/start_influxdb.sh
ADD opt/influxdb/current/config.toml /opt/influxdb/current/config.toml

ADD opt/qnib/bin/bootstrap_influxdb.sh /opt/qnib/bin/bootstrap_influxdb.sh
ADD opt/influxdb/etc/default_db.json /opt/influxdb/etc/default_db.json
ADD opt/influxdb/etc/graphite_db.json /opt/influxdb/etc/graphite_db.json

# put the database into a volume (if not maped)
VOLUME ["/opt/influxdb/shared"]

# Admin API Raft Replication
EXPOSE 8083 8086 8090 8099

# Graphite
EXPOSE 2003 2003/udp

ENV ROOT_PASSWORD root
ENV GRAPHITE_DATABASE graphite
ENV GRAPHITE_USERNAME graphite
ENV GRAPHITE_PASSWORD graphite
ENV DEFAULT_DATABASE default
ENV DEFAULT_USERNAME default
ENV DEFAULT_PASSWORD default
