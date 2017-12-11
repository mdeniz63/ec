FROM local/c7-systemd
LABEL maintainer "Mahmut Deniz"

USER root

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

RUN rm -f /var/lib/rpm/__db*
RUN rpm --rebuilddb
RUN yum -y update && yum clean all
RUN yum -y install systemd-sysv
RUN yum -y install libxslt

# iki dosya lazım
COPY nitro.tar.gz /
COPY install.sh /
WORKDIR /

RUN ./install.sh

ADD VERSION /
ADD ChangeLogs /

RUN localedef -i tr_TR -c -f UTF-8 -A /usr/share/locale/locale.alias tr_TR.UTF-8

RUN systemctl enable postgresql.service
RUN systemctl enable tomcat.service

EXPOSE 8181 5432
