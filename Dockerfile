FROM registry.access.redhat.com/ubi8/ubi:latest
LABEL url=https://github.com/sharkcz/collectl/tree/9e4cd81389acac303b1bb120277b59b28d5ab188
LABEL version=4.3.20
COPY entrypoint.sh /opt/entrypoint.sh
WORKDIR /opt
RUN yum -y install pciutils procps-ng hostname perl tar \
 && yum clean all \
 && curl -skLo /opt/collectl-4.3.20.tar.gz https://github.com/sharkcz/collectl/archive/refs/tags/4.3.20.tar.gz \
 && tar xvf collectl-4.3.20.tar.gz \
 && cd collectl-4.3.20 \
 && ./INSTALL \
 && chmod 755 /opt/entrypoint.sh
CMD /opt/entrypoint.sh
