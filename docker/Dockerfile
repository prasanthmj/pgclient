FROM alpine:latest

ENV X_RCLONE_VERSION=current
ENV ARCH=arm64

RUN apk update && \
    apk upgrade && \
    apk --no-cache add postgresql-client>14.3-r0 bash && \
    apk --no-cache  add \
        openssl \
        ca-certificates \
        fuse \
    && cd /tmp \
    && wget -q http://downloads.rclone.org/rclone-${X_RCLONE_VERSION}-linux-${ARCH}.zip \
    && unzip /tmp/rclone-${X_RCLONE_VERSION}-linux-${ARCH}.zip \
    && mv /tmp/rclone-*-linux-${ARCH}/rclone /usr/bin \
    && rm -r /tmp/rclone* 

COPY ./createdb.sh /scripts/createdb.sh
COPY ./backup.sh /scripts/backup.sh

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"