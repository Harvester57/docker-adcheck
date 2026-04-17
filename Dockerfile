# Source: https://hub.docker.com/_/python
FROM python:3.14-alpine@sha256:01f125438100bb6b5770c0b1349e5200b23ca0ae20a976b5bd8628457af607ae

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