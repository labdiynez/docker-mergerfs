FROM ubuntu:18.04 as builder

ARG DEBIAN_FRONTEND="noninteractive"

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        ca-certificates curl libfuse2

ARG MERGERFS_VERSION

# install mergerfs
RUN debfile="/tmp/mergerfs.deb" && curl -fsSL -o "${debfile}" "https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}"


FROM ubuntu@sha256:b58746c8a89938b8c9f5b77de3b8cf1fe78210c696ab03a1442e235eea65d84f
LABEL maintainer="hotio"

ARG DEBIAN_FRONTEND="noninteractive"

ENTRYPOINT ["mergerfs"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libfuse2 && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY --from=builder /usr/bin/mergerfs /usr/bin/mergerfs
COPY --from=builder /usr/bin/mergerfs-fusermount /usr/bin/mergerfs-fusermount
COPY --from=builder /usr/sbin/mount.mergerfs /usr/sbin/mount.mergerfs
