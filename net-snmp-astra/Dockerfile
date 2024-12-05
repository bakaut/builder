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

RUN wget -qO - https://glaber.io/repo/key/repo.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/glaber_repo.gpg && \
    echo "deb [arch=amd64] https://glaber.io/repo/astra 1.7.3 main" >> /etc/apt/sources.list.d/glaber.list && \
    apt-get update && apt-get install -y net-snmp

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN GO_VER=1.20.5 && \
    wget -q https://golang.org/dl/go${GO_VER}.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go${GO_VER}.linux-amd64.tar.gz && \
    rm go${GO_VER}.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
