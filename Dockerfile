FROM alpine:3.19

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL mantainer="pengshp <pengshp@gmail.com>" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="Samba4" \
    org.label-schema.description="Multi-arch Samba4 for amd64 arm32v7 or arm64" \
    org.label-schema.url="https://samba.org" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/pengshp/samba" \
    org.label-schema.vendor="pengshp" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="2.0"

RUN set -xe \
    && apk update \
    && apk add --no-cache bash samba-common-tools samba tzdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

VOLUME [ "/share" ]
WORKDIR /share

HEALTHCHECK --interval=60s --timeout=15s CMD smbclient -L \\localhost -U % -m SMB3

CMD ["-h"]
ENTRYPOINT ["/entrypoint.sh"]
