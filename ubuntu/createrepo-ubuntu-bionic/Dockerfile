FROM ubuntu:bionic

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    bzip2 \
    cmake \
    libbz2-dev \
    libglib2.0-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libpython3-dev \
    librpm-dev \
    libssl-dev \
    libsqlite3-dev \
    liblzma-dev \
    zlib1g-dev \
    libzstd-dev \
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
