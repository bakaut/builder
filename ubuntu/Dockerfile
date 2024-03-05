FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
    apt-get --ignore-missing install -yqq jq \
    cmake libgmp3-dev gengetopt ccache \
    libpcap-dev flex byacc libjson-c-dev \
    libunistring-dev dpkg-dev devscripts wget git gcc \
    automake dh-make build-essential autoconf autotools-dev \
    quilt pkg-config libsnmp-dev libpq-dev libsqlite3-dev \
    libcurl4-openssl-dev libldap2-dev libiksemel-dev \
    libopenipmi-dev libssh2-1-dev unixodbc-dev default-jdk \
    libxml2-dev libpcre3-dev libevent-dev curl libssl-dev \
    lsb-release default-libmysqlclient-dev libssh-dev sass

RUN lsb_release -cs | grep bionic && \
    apt-get install -y g++-8 && \
    rm -rf /usr/bin/g++ && \
    ln -s /usr/bin/x86_64-linux-gnu-g++-8 /usr/bin/g++ && \
    g++ --version || true

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN GO_VER=1.20.5 && \
    wget -q https://golang.org/dl/go${GO_VER}.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go${GO_VER}.linux-amd64.tar.gz && \
    rm go${GO_VER}.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
