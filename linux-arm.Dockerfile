FROM hotio/base@sha256:d668da1b18583d94b5ddb8e8c25012d24bf3ad54231ab8af2f0ed0ca02bcc6ff

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
RUN debfile="/tmp/mergerfs.deb" && curl -fsSL -o "${debfile}" "https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_armhf.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
