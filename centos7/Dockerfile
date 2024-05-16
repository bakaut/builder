FROM centos:7

# Install common packages
RUN yum install -y epel-release yum-utils && \
    yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y ccache rpm-build xz wget rsync tar curl cmake json-c-devel gengetopt libunistring-devel libpcap-devel gmp-devel git sqlite-devel unixODBC-devel net-snmp-devel libxml2-devel libssh2-devel OpenIPMI OpenIPMI-devel libevent-devel openldap-devel libcurl-devel && \
    yum install -y centos-release-scl && \
    yum install -y devtoolset-8-gcc devtoolset-8-gcc-c++

# Install Golang
RUN GO_VER=1.20.5 && \
    wget -q https://golang.org/dl/go${GO_VER}.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go${GO_VER}.linux-amd64.tar.gz && \
    rm go${GO_VER}.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

ENTRYPOINT ["/usr/bin/scl", "enable", "devtoolset-8", "--", "bash" ]
