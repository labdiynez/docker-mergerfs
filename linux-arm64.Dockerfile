FROM hotio/base@sha256:e0a32794663c42ab2b15dcbaadc560dd8c4d6b8f90b61a49d8d11048189fbeb1

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

ARG MERGERFS_VERSION

# install mergerfs
RUN debfile="/tmp/mergerfs.deb" && curl -fsSL -o "${debfile}" "https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
