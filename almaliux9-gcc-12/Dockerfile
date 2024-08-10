FROM almalinux:9

RUN dnf -y update && \
    dnf install -y jq \
    cmake gmp-devel gengetopt ccache rsync \
    libpcap-devel flex byacc json-c-devel \
    libunistring-devel rpm-build rpmdevtools wget git \
    automake dh-make gcc gcc-c++ autoconf libtool \
    quilt pkgconf snmp-devel postgresql-devel sqlite-devel \
    libcurl-devel openldap-devel iksemel-devel \
    OpenIPMI-devel libssh2-devel unixODBC-devel java-11-openjdk-devel \
    libxml2-devel pcre-devel libevent-devel curl openssl-devel \
    redhat-lsb-core mariadb-devel libssh-devel sass

RUN set -eux; \
    dnf install -y --setopt=install_weak_deps=False \
    # install abigail-tools so we can use abidiff later to verify that we don't break AlmaLinux packages
        abigail-tools \
    ; \
    dnf clean all

# https://gcc.gnu.org/mirrors.html
ENV GPG_KEYS \
# 1024D/745C015A 1999-11-09 Gerald Pfeifer <gerald@pfeifer.com>
    B215C1633BCA0477615F1B35A5B3A004745C015A \
# 1024D/B75C61B8 2003-04-10 Mark Mitchell <mark@codesourcery.com>
    B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8 \
# 1024D/902C9419 2004-12-06 Gabriel Dos Reis <gdr@acm.org>
    90AA470469D3965A87A5DCB494D03953902C9419 \
# 1024D/F71EDF1C 2000-02-13 Joseph Samuel Myers <jsm@polyomino.org.uk>
    80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C \
# 2048R/FC26A641 2005-09-13 Richard Guenther <richard.guenther@gmail.com>
    7F74F97C103468EE5D750B583AB00996FC26A641 \
# 1024D/C3C45C06 2004-04-21 Jakub Jelinek <jakub@redhat.com>
    33C235A34C46AA3FFB293709A328C3A2C3C45C06 \
# 4096R/09B5FA62 2020-05-28 Jakub Jelinek <jakub@redhat.com>
    D3A93CAD751C2AF4F8C7AD516C35B99309B5FA62

# https://gcc.gnu.org/mirrors.html
ENV GCC_MIRRORS \
        https://ftpmirror.gnu.org/gcc \
        https://mirrors.kernel.org/gnu/gcc \
        https://bigsearcher.com/mirrors/gcc/releases \
        http://www.netgull.com/gcc/releases \
        https://ftpmirror.gnu.org/gcc \
# "sourceware.org" is the canonical upstream release host (the host of "gcc.gnu.org")
        https://sourceware.org/pub/gcc/releases \
# only attempt the origin FTP as a mirror of last resort
        ftp://ftp.gnu.org/gnu/gcc

# Last Modified: 2024-06-20
ENV GCC_VERSION 12.4.0
# Docker EOL: 2025-12-20

RUN set -ex; \
    \
    savedDnfMark="$(dnf mark install | grep -E 'install|reason')"; \
    dnf install -y --setopt=install_weak_deps=False \
        rpm-build \
        flex \
        gnupg2 \
    ; \
    dnf clean all; \
    \
    _fetch() { \
        local fetch="$1"; shift; \
        local file="$1"; shift; \
        for mirror in $GCC_MIRRORS; do \
            if curl -fL "$mirror/$fetch" -o "$file"; then \
                return 0; \
            fi; \
        done; \
        echo >&2 "error: failed to download '$fetch' from several mirrors"; \
        return 1; \
    }; \
    \
    _fetch "gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz.sig" 'gcc.tar.xz.sig'; \
    _fetch "gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz" 'gcc.tar.xz'; \
    export GNUPGHOME="$(mktemp -d)"; \
    for key in $GPG_KEYS; do \
        gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
    done; \
    gpg --batch --verify gcc.tar.xz.sig gcc.tar.xz; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME"; \
    mkdir -p /usr/src/gcc; \
    tar -xf gcc.tar.xz -C /usr/src/gcc --strip-components=1; \
    rm gcc.tar.xz*; \
    \
    cd /usr/src/gcc; \
    \
# "download_prerequisites" pulls down a bunch of tarballs and extracts them,
# but then leaves the tarballs themselves lying around
    ./contrib/download_prerequisites; \
    { rm *.tar.* || true; }; \
    \
# explicitly update autoconf config.guess and config.sub so they support more arches/libcs
    for f in config.guess config.sub; do \
        wget -O "$f" "https://git.savannah.gnu.org/cgit/config.git/plain/$f?id=7d3d27baf8107b630586c962c057e22149653deb"; \
# find any more (shallow) copies of the file we grabbed and update them too
        find -mindepth 2 -name "$f" -exec cp -v "$f" '{}' ';'; \
    done; \
    \
    dir="$(mktemp -d)"; \
    cd "$dir"; \
    \
    extraConfigureArgs=''; \
    gnuArch="$(uname -m)"; \
    case "$gnuArch" in \
# with-arch: for ARM
        armv7l) \
            extraConfigureArgs="$extraConfigureArgs --with-arch=armv7-a+fp --with-float=hard --with-mode=thumb" \
            ;; \
        armv6l) \
            extraConfigureArgs="$extraConfigureArgs --with-arch=armv6 --with-float=hard" \
            ;; \
        \
# with-arch-32: for i386
        i386) \
            extraConfigureArgs="$extraConfigureArgs --with-arch-32=i686"; \
            ;; \
    esac; \
    \
    /usr/src/gcc/configure \
        --disable-multilib \
        --enable-languages=c,c++,fortran,go \
        $extraConfigureArgs \
    ; \
    make -j "$(nproc)"; \
    make install-strip; \
    \
    cd ..; \
    \
    rm -rf "$dir" /usr/src/gcc; \
    \
    dnf mark install --setopt=install_weak_deps=False $savedDnfMark; \
    dnf autoremove -y

# gcc installs .so files in /usr/local/lib64 (and /usr/local/lib)...
RUN set -ex; \
# this filename needs to sort higher than all the architecture filenames ("aarch64-...", "armeabi...", etc)
    { echo '/usr/local/lib64'; echo '/usr/local/lib'; } > /etc/ld.so.conf.d/000-local-lib.conf; \
    ldconfig -v; \
    # the libc created by gcc might be too old for a newer AlmaLinux
    # check that the AlmaLinux libstdc++ doesn't have newer requirements than the gcc one
    gccLib="$(readlink -ve /usr/local/lib*/libstdc++.so | head -1)"; \
    debLib="$(readlink -ve /usr/lib/*/libstdc++.so* | head -1)"; \
# using LD_PRELOAD to make sure "abidiff" itself doesn't fail with the exact error we're trying to test for 😂😭
    LD_PRELOAD="$gccLib" abidiff --no-added-syms "$debLib" "$gccLib"

# ensure that alternatives are pointing to the new compiler and that the old one is no longer used
RUN set -ex; \
    mv /usr/bin/gcc /usr/bin/gcc.orig; \
    mv /usr/bin/g++ /usr/bin/g++.orig; \
    mv /usr/bin/gfortran /usr/bin/gfortran.orig; \
    ln -sf /usr/local/bin/gcc /usr/bin/cc; \
    ln -sf /usr/local/bin/gcc /usr/bin/gcc; \
    ln -sf /usr/local/bin/g++ /usr/bin/g++; \
    ln -sf /usr/local/bin/gfortran /usr/bin/gfortran

RUN dnf clean all

RUN GO_VER=1.20.5 && \
    wget -q https://golang.org/dl/go${GO_VER}.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go${GO_VER}.linux-amd64.tar.gz && \
    rm go${GO_VER}.linux-amd64.tar.gz

ENV PATH="/usr/local/bin:/usr/local/go/bin:${PATH}"

RUN gcc --version && \
    g++ --version && \
    go version
