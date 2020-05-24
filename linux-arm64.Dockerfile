FROM ubuntu@sha256:2b90cad5ded7946db07a28252618b9c8b7f4f103fc39266bcc795719d1362d40
LABEL maintainer="hotio"

ARG DEBIAN_FRONTEND="noninteractive"

ENTRYPOINT ["mergerfs"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        ca-certificates curl fuse && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG MERGERFS_VERSION

# install mergerfs
RUN debfile="/tmp/mergerfs.deb" && curl -fsSL -o "${debfile}" "https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"
