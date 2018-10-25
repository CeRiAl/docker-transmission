#!/usr/bin/env bash
set -e  # Exit on error

IMAGE_NAME="cryptopath/transmission"
VERSION="$(cat VERSION)"
REVISION="$(git rev-parse --short HEAD)"
BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

echo -e "NAME:\t\t${IMAGE_NAME}"
echo -e "VERSION:\t${VERSION}"
echo -e "REVISION:\t${REVISION}"
echo -e "BUILD_DATE:\t${BUILD_DATE}"

docker build \
  --build-arg VERSION="${VERSION}" \
  --build-arg REVISION="${REVISION}" \
  --build-arg BUILD_DATE="${BUILD_DATE}" \
  --tag ${IMAGE_NAME}:latest \
  --tag ${IMAGE_NAME}:${VERSION}  .
