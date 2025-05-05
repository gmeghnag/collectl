FROM registry.access.redhat.com/ubi9/ubi:latest
LABEL url=https://github.com/sharkcz/collectl/tree/9e4cd81389acac303b1bb120277b59b28d5ab188
LABEL version=4.3.20
COPY entrypoint.sh /opt/entrypoint.sh
RUN yum -y install man-db pciutils procps-ng hostname perl tar \
 && yum clean all \
 && curl -skLo /opt/collectl-4.3.20.tar.gz https://github.com/sharkcz/collectl/archive/refs/tags/4.3.20.tar.gz \
 && tar xvf /opt/collectl-4.3.20.tar.gz -C /opt \
 && cd /opt/collectl-4.3.20 \
 && ./INSTALL \
 && chmod 755 /opt/entrypoint.sh
WORKDIR /var/log/collectl
CMD /opt/entrypoint.sh
