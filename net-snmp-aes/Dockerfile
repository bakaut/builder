FROM debian:bullseye AS net-snmp-builder

RUN apt update && apt upgrade -y
RUN echo "deb-src http://deb.debian.org/debian/ bullseye main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list && \
    echo "deb-src http://deb.debian.org/debian/ bullseye-updates main" >> /etc/apt/sources.list

RUN apt update && \
  apt-get install -y aptitude devscripts build-essential lintian \
  libwrap0-dev libssl-dev perl-xs-dev procps pkg-config \
  libsensors-dev default-libmysqlclient-dev libpci-dev

RUN cd /tmp && apt source libsnmp40 && \
    cd net-snmp-5.9+dfsg/ && \
    sed -i '39a--enable-blumenthal-aes \\' debian/rules && \
    debuild -us -uc

FROM debian:bullseye
RUN apt update && apt upgrade -y

COPY --from=net-snmp-builder /tmp/net-snmp-5.9+dfsg/*.deb /tmp/

RUN dpkg -i /tmp/*.deb
