FROM debian:bullseye AS net-snmp-builder

RUN apt update && apt upgrade -y
RUN echo "deb-src http://deb.debian.org/debian/ bullseye main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list && \
    echo "deb-src http://deb.debian.org/debian/ bullseye-updates main" >> /etc/apt/sources.list

RUN apt update && apt install -y aptitude devscripts build-essential lintian

RUN cd /tmp && apt source libsnmp40 && \
    cd net-snmp-5.9+dfsg/ && \
    sed -i '39s/$/ --enable-blumenthal-aes/' debian/rules && \
    debuild -us -uc

FROM debian:bullseye
RUN apt update && apt upgrade -y
RUN apt-get install -y \
    devscripts build-essential lintian

COPY --from=net-snmp-builder /tmp/net-snmp-5.9+dfsg/*.deb /tmp/

RUN dpkg -i /tmp/*.deb
