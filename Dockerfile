FROM qnib/terminal

RUN yum install -y https://s3.amazonaws.com/influxdb/influxdb-0.9.5.1-1.x86_64.rpm
ADD etc/supervisord.d/influxdb.ini /etc/supervisord.d/influxdb.ini
ADD opt/qnib/influxdb/bin/start.sh /opt/qnib/influxdb/bin/
ADD etc/influxdb/influxdb.conf /etc/influxdb/

ADD opt/influxdb/etc/ /opt/influxdb/etc/
ADD etc/consul.d/*.json /etc/consul.d/

# put the database into a volume (if not maped)
VOLUME ["/opt/influxdb/shared"]

# Admin API Raft Replication
EXPOSE 8083 8086 8090 8099

# Graphite
EXPOSE 2003 2003/udp
# OpenTSDB
EXPOSE 4242

ENV ROOT_PASSWORD=root \
    METRIC_DATABASE=carbon \
    METRIC_USERNAME=carbon \
    METRIC_PASSWORD=carbon \
    DASHBOARD_DATABASE=default \
    DASHBOARD_USERNAME=default \
    DASHBOARD_PASSWORD=default
RUN echo "tail -n500 -f /var/log/supervisor/influxdb.log" >> /root/.bash_history
