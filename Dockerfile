# Source: https://hub.docker.com/_/python
FROM python:3.14-alpine@sha256:b80c82b1a282283bd3e3cd3c6a4c895d56d1385879c8c82fa673e9eb4d6d4aa5

LABEL maintainer="florian.stosse@gmail.com"
LABEL lastupdate="2025-11-02"
LABEL author="Florian Stosse"
LABEL description="ADCheck, built using Alpine image with Python 3.14"
LABEL license="MIT license"

RUN apk update && \
    apk upgrade --available && \
    /usr/local/bin/python -m pip install --upgrade pip && \
    apk add --no-cache -t .required_apks git bash
  
RUN addgroup -g 666 appuser && \
    mkdir -p /home/appuser && \
    adduser -D -h /home/appuser -u 666 -G appuser appuser && \
    chown -R appuser:appuser /home/appuser
ENV PATH="/home/appuser/.local/bin:${PATH}"
USER appuser

RUN python -m pip install pipx && pipx ensurepath && pipx install git+https://github.com/CobblePot59/ADcheck.git

USER root
RUN apk del .required_apks && \
    rm -rf /var/cache/apk/*

USER appuser

ENTRYPOINT [ "adcheck" ]