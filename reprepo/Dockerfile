FROM ubuntu:18.04 as builder

LABEL maintainer="fifo.mail@gmail.com"

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
    autoconf \
    automake \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
RUN git clone --branch multiple-versions-debian https://github.com/ionos-cloud/reprepro.git

# Ensure you're in the correct directory where the Makefile exists
WORKDIR /usr/src/reprepro
RUN sh ./configure && make && make install

RUN ./reprepro --version

# Stage 2: Final Stage
FROM ubuntu:18.04

LABEL maintainer="fifo.mail@gmail.com"

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libdb5.3 \
    libgpgme11 \
    zlib1g \
    libbz2-1.0 \
    liblzma5 \
    libc6 \
 && rm -rf /var/lib/apt/lists/*

# Copy the built reprepro binary from the build stage
COPY --from=builder /usr/src/reprepro/reprepro /usr/local/bin/reprepro

RUN reprepro --version

# Set a default command for the container (optional)
CMD ["reprepro", "--version"]