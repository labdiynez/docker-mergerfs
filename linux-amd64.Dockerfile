FROM ubuntu@sha256:5747316366b8cc9e3021cd7286f42b2d6d81e3d743e2ab571f55bcd5df788cc8
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
RUN debfile="/tmp/mergerfs.deb" && curl -fsSL -o "${debfile}" "https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}"
