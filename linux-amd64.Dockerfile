FROM hotio/base@sha256:75b16518487eb5cf1b65f55132938dbee7f954d82b8c13d4b0175780ada14ff7

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
RUN debfile="/tmp/mergerfs.deb" && curl -fsSL -o "${debfile}" "https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
