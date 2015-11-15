FROM qnib/terminal

RUN INFLUX_VER=0.9.4.2-1 yum install -y https://s3.amazonaws.com/influxdb/influxdb-${INFLUX_VER}.x86_64.rpm
ADD etc/supervisord.d/influxdb.ini /etc/supervisord.d/influxdb.ini
ADD opt/qnib/bin/start_influxdb.sh /opt/qnib/bin/start_influxdb.sh
ADD opt/influxdb/current/config.toml /opt/influxdb/current/config.toml

ADD opt/influxdb/etc/ /opt/influxdb/etc/
ADD etc/consul.d/check_influxdb.json /etc/consul.d/check_influxdb.json
ADD etc/consul.d/check_carbon.json /etc/consul.d/check_carbon.json

# put the database into a volume (if not maped)
VOLUME ["/opt/influxdb/shared"]

# Admin API Raft Replication
EXPOSE 8083 8086 8090 8099

# Graphite
EXPOSE 2003 2003/udp
EXPOSE 4242

ENV ROOT_PASSWORD root
ENV METRIC_DATABASE carbon
ENV METRIC_USERNAME carbon
ENV METRIC_PASSWORD carbon
ENV DASHBOARD_DATABASE default
ENV DASHBOARD_USERNAME default
ENV DASHBOARD_PASSWORD default
