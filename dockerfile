# Usage: FROM [image name]
FROM debian

# Usage: MAINTAINER [name]
MAINTAINER weezhard

# Variables
ENV INFLUXDB_VERSION 0.13.0

RUN apt-get update && \
    apt-get install -y -q wget curl

# Install elasticsearch
RUN wget -q https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb -O /opt/influxdb.deb && \
    cd /opt && dpkg -i influxdb.deb

# Clean apt
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /opt/influxdb.deb

# Add config
RUN influxd config > /etc/influxdb/influxdb..conf
COPY conf/influxdb-entrypoint /

# Add VOLUMEs logs and data
VOLUME  ["/var/lib/influxdb"]

# Expose and Startup
EXPOSE 8083 8086

CMD ["influxd"]
