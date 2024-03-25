FROM ubuntu:bionic

# Install build dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    make \
    libcurl4-openssl-dev \
    gcc \
    libglib2.0-dev \
    libxml2-dev \
    libssl-dev \
    libbz2-dev \
    liblzma-dev \
    zlib1g-dev \
    rpm \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone the createrepo_c repository
RUN git clone https://github.com/rpm-software-management/createrepo_c.git

# Build createrepo_c from source
RUN mkdir /createrepo_c/build && cd /createrepo_c/build && \
    cmake .. && \
    make && \
    make install

# Set the entrypoint to createrepo_c
ENTRYPOINT [ "createrepo_c" ]
