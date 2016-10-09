FROM qnib/alpn-consul

ENV ROOT_PASSWORD=root \
    METRIC_DATABASE=carbon \
    METRIC_USERNAME=carbon \
    METRIC_PASSWORD=carbon \
    DASHBOARD_DATABASE=default \
    DASHBOARD_USERNAME=default \
    DASHBOARD_PASSWORD=default \
    INFLUXDB_META_PORT=8088 \
    INFLUXDB_META_HTTP_PORT=8091 \
    INFLUXDB_ADMIN_PORT=8083 \
    INFLUXDB_HTTP_PORT=8086 \
    INFLUXDB_OPENTSDB_PORT=4242 \
    INFLUXDB_GRAPHITE_ENABLED=false \
    INFLUXDB_COLLECTD_ENABLED=false \
    INFLUXDB_OPENTSDB_ENABLED=false \
    INFLUXDB_DATABASES=fullerite
ENV INFLUXDB_VER=1.0.2
ENV INFLUXDB_URL=https://dl.influxdata.com/influxdb/releases
RUN apk --no-cache add wget \
 && wget -qO - ${INFLUXDB_URL}/influxdb-${INFLUXDB_VER}_linux_amd64.tar.gz |tar xfz - -C /opt/ \
 && mv $(find /opt/ -type d -name "influxdb*" -maxdepth 1) /opt/influxdb \
 && mkdir -p /usr/share/collectd/ \
 && wget -qO /usr/share/collectd/types.db https://raw.githubusercontent.com/collectd/collectd/master/src/types.db

ADD etc/supervisord.d/influxdb.ini \
    etc/supervisord.d/influxdb-init.ini \
    /etc/supervisord.d/
ADD opt/qnib/influxdb/bin/start.sh \
    opt/qnib/influxdb/bin/init.sh \
    /opt/qnib/influxdb/bin/
#ADD opt/influxdb/etc/ /opt/influxdb/etc/
ADD etc/consul.d/*.json /etc/consul.d/
# put the database into a volume (if not maped)

RUN echo "tail -n500 -f /var/log/supervisor/influxdb.log" >> /root/.bash_history
ADD etc/consul-templates/influxdb/influxdb.conf.ctmpl /etc/consul-templates/influxdb/
VOLUME ["/opt/influxdb/shared/data"]
