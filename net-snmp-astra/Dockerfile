FROM registry.astralinux.ru/library/alse:1.7.3

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
    apt-get --ignore-missing install -yqq jq \
    cmake libgmp3-dev gengetopt ccache rsync \
    libpcap-dev flex byacc libjson-c-dev \
    libunistring-dev dpkg-dev devscripts wget git gcc \
    automake dh-make build-essential autoconf autotools-dev \
    quilt pkg-config libsnmp-dev libpq-dev libsqlite3-dev \
    libcurl4-openssl-dev libldap2-dev libiksemel-dev \
    libopenipmi-dev libssh2-1-dev unixodbc-dev default-jdk \
    libxml2-dev libpcre3-dev libevent-dev curl libssl-dev \
    lsb-release default-libmysqlclient-dev libssh-dev sass

RUN lsb_release -cs | grep bullseye && \
    apt-get install -y libmariadb-dev || true

RUN apt-get install -y wget libgdbm-compat4 libgdbm6 libpci3 libperl5.28 libsensors-config libsensors5 libwrap0 netbase perl perl-modules-5.28 && \
    wget https://glaber.io/repo/astra/pool/main/n/net-snmp/s1_libsnmp-base_5.9%2Bastra173.deb && \
    dpkg -i s1_libsnmp-base_5.9+astra173.deb && \
    wget https://glaber.io/repo/astra/pool/main/n/net-snmp/s2_libsnmp40_5.9%2Bastra173.deb && \
    dpkg -i s2_libsnmp40_5.9+astra173.deb

RUN apt-get clean && rm -rf /var/lib/apt/lists/* s1_libsnmp-base_5.9+astra173.deb s2_libsnmp40_5.9+astra173.deb

RUN GO_VER=1.20.5 && \
    wget -q https://golang.org/dl/go${GO_VER}.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go${GO_VER}.linux-amd64.tar.gz && \
    rm go${GO_VER}.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
