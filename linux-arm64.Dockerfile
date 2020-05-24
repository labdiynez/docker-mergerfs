FROM ubuntu:18.04 as builder

ARG DEBIAN_FRONTEND="noninteractive"

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        ca-certificates curl fuse

ARG MERGERFS_VERSION

# install mergerfs
RUN debfile="/tmp/mergerfs.deb" && curl -fsSL -o "${debfile}" "https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"


FROM ubuntu@sha256:03e4a3b262fd97281d7290c366cae028e194ae90931bc907991444d026d6392a
LABEL maintainer="hotio"

ARG DEBIAN_FRONTEND="noninteractive"

ENTRYPOINT ["mergerfs"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        fuse && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY --from=builder /usr/bin/mergerfs /usr/bin/mergerfs
COPY --from=builder /usr/bin/mergerfs-fusermount /usr/bin/mergerfs-fusermount
COPY --from=builder /usr/sbin/mount.mergerfs /usr/sbin/mount.mergerfs
