FROM cryptopath/alpine:3.8

# set version, revision and build-date labels
ARG VERSION="dev"
ARG REVISION="HEAD"
ARG BUILD_DATE="unknown"

# metadata as defined in Open Container Initiative (OCI) annotations specs
# -> https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.title="cryptopath/transmission" \
      org.opencontainers.image.description="Nicely configurable Transmission BitTorrent client inside a docker container" \
      org.opencontainers.image.vendor="Cryptopath" \
      org.opencontainers.image.authors="CeRiAl <ikhatib@gmail.com>" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://hub.docker.com/r/cryptopath/transmission/" \
      org.opencontainers.image.documentation="https://github.com/CeRiAl/docker-transmission#readme" \
      org.opencontainers.image.source="https://github.com/CeRiAl/docker-transmission" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${REVISION}" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.ref.name="cryptopath-transmission-${VERSION}"

RUN \
  echo "**** install packages ****" && \
    apk add --no-cache \
      curl \
      jq \
      openssl \
      p7zip \
      rsync \
      tar \
      transmission-cli \
      transmission-daemon \
      unrar \
      unzip

# copy local files
COPY root/ /

# environment
ENV CONFIG_PATH="/vol/config" \
    DOWNLOADS_PATH="/vol/downloads" \
    WATCH_PATH="/vol/watch"

# ports and volumes
EXPOSE 9091 51413
VOLUME /vol

# healthcheck
HEALTHCHECK CMD curl -Isf http://localhost:9091/; RES=$?; ([ "$RES" -eq 0 ] || [ "$RES" -eq 22 ]) || exit 1;
