FROM alpine:3.11 as builder

# install packages
RUN apk add --no-cache fuse libattr libgcc libstdc++ autoconf automake libtool gettext-dev attr-dev linux-headers curl

ARG MERGERFS_VERSION

# install mergerfs
RUN mkdir /mergerfs && \
    curl -fsSL "https://github.com/trapexit/mergerfs/archive/v${MERGERFS_VERSION}.tar.gz" | tar xzf - -C "/mergerfs" --strip-components=1 && \
    cd /mergerfs && \
    make && make install


FROM alpine@sha256:39eda93d15866957feaee28f8fc5adb545276a64147445c64992ef69804dbf01
LABEL maintainer="hotio"

ENTRYPOINT ["mergerfs", "-f"]

# install packages
RUN apk add --no-cache fuse libattr libgcc libstdc++

COPY --from=builder /usr/local/bin/mergerfs /usr/local/bin/mergerfs
COPY --from=builder /usr/local/bin/mergerfs-fusermount /usr/local/bin/mergerfs-fusermount
COPY --from=builder /usr/local/sbin/mount.mergerfs /usr/local/sbin/mount.mergerfs
