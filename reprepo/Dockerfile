FROM ubuntu:18.04

LABEL maintainer="yourname@example.com"

RUN apt-get update && apt-get install -y \
    build-essential \
    devscripts \
    debhelper \
    libdb-dev \
    libgpgme11-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libarchive-dev \
    git \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
RUN git clone https://github.com/ionos-cloud/reprepro.git

WORKDIR /usr/src/reprepro
RUN make && make install

RUN reprepro --version

# Set a default command for the container (optional)
CMD ["reprepro", "--version"]
