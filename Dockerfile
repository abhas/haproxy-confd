FROM haproxy:1.5
ENV confd_ver 0.9.0
ENV ETCD_NODE 172.17.42.1:4001
RUN apt-get update && \
  apt-get install -y syslogd && \
  apt-get clean
ADD https://github.com/kelseyhightower/confd/releases/download/v${confd_ver}/confd-${confd_ver}-linux-amd64 /usr/local/bin/confd
ADD confd /etc/confd
RUN chmod +x /usr/local/bin/confd
CMD  syslogd && \
  confd -onetime -node $ETCD_NODE && \
  confd -node $ETCD_NODE -watch & \
  touch /var/log/messages && \
  tail -fn+0 /var/log/messages