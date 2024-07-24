FROM alpine:3.19

LABEL maintainer="Peter Dave Hello <hsu@peterdavehello.org>"
LABEL name="tor-socks-proxy"
LABEL version="latest"

RUN echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    apk -U upgrade && \
    apk -v add tor@edge curl && \
    apk add obfs4proxy --update-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    chmod 700 /var/lib/tor && \
    rm -rf /var/cache/apk/* && \
    tor --version
COPY --chown=tor:root torrc /etc/tor/

HEALTHCHECK --timeout=10s --start-period=60s \
    CMD curl --fail --socks5-hostname localhost:9050 -I -L 'https://www.facebookwkhpilnemxj7asaniu7vnjjbiltxjqhye3mhbshg7kx5tfyd.onion/' || exit 1

USER tor
EXPOSE 8853/udp 9050/tcp 9040/tcp 9150/tcp

CMD ["/usr/bin/tor", "-f", "/etc/tor/torrc"]
