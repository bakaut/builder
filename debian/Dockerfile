FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
    apt-get --ignore-missing install -yqq jq \
    cmake libgmp3-dev gengetopt ccache rsync \
    libpcap-dev flex byacc libjson-c-dev \
    libunistring-dev dpkg-dev devscripts wget git \
    automake dh-make build-essential autoconf autotools-dev \
    quilt pkg-config libsnmp-dev libpq-dev libsqlite3-dev \
    libcurl4-openssl-dev libldap2-dev libiksemel-dev \
    libopenipmi-dev libssh2-1-dev unixodbc-dev default-jdk \
    libxml2-dev libpcre3-dev libevent-dev curl libssl-dev \
    lsb-release default-libmysqlclient-dev libssh-dev sass

RUN wget -q https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.gz && \
    tar -xzf gcc-11.2.0.tar.gz && \
    cd gcc-11.2.0 && \
    ./contrib/download_prerequisites && \
    mkdir ../gcc-build && cd ../gcc-build && \
    ../gcc-11.2.0/configure --prefix=/usr/local/gcc-11.2.0 --enable-languages=c,c++ --disable-multilib && \
    make -j8 -d && \
    make install -d

RUN lsb_release -cs | grep bullseye && \
    apt-get install -y libmariadb-dev || true

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN GO_VER=1.20.5 && \
    wget -q https://golang.org/dl/go${GO_VER}.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go${GO_VER}.linux-amd64.tar.gz && \
    rm go${GO_VER}.linux-amd64.tar.gz

ENV PATH="/usr/local/gcc-11.2.0/x86_64-pc-linux-gnu/bin/:/usr/local/go/bin:${PATH}"

RUN gcc --version && \
    g++ --version && \
    go version
