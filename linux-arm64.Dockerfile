FROM hotio/base@sha256:4a7639467e698caaf379f8edb84b226ffccb6f4643372e09a0cca0bba037966b

ARG DEBIAN_FRONTEND="noninteractive"

ENV BRANCHES="/source1:/source2" MOUNTPOINT="/mountpoint"

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        fuse && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG MERGERFS_VERSION=2.29.0

# install mergerfs
RUN debfile="/tmp/mergerfs.deb" && curl -fsSL -o "${debfile}" "https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
