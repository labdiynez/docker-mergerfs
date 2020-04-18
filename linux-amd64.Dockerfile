FROM hotio/base@sha256:29d40ed2eecd505d6f6c2c460f732ee5fa2a20d87d17aacdd50a9d6e098b0afe

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
