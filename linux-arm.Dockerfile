FROM hotio/base@sha256:8598d7707dd3e8471cf80df6a471a1f100f207ca5f1e33b08e6b0a64d961e3dd

ARG DEBIAN_FRONTEND="noninteractive"

ENV OPTIONS="" BRANCHES="" MOUNTPOINT="/mountpoint"

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
RUN debfile="/tmp/mergerfs.deb" && curl -fsSL -o "${debfile}" "https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_armhf.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
