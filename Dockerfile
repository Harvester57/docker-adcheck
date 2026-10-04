# Source: https://hub.docker.com/_/python
FROM python:3.14-alpine@sha256:5a824eb82cc75361f98611f3cfc5091ea33f10a6ccea4d4ebdabbc523b9a1614 AS builder

RUN apk add --no-cache git

WORKDIR /app
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir git+https://github.com/CobblePot59/ADcheck.git

FROM python:3.14-alpine@sha256:5a824eb82cc75361f98611f3cfc5091ea33f10a6ccea4d4ebdabbc523b9a1614

LABEL org.opencontainers.image.authors="Florian Stosse <florian.stosse@gmail.com>"
LABEL org.opencontainers.image.created="2025-11-02"
LABEL org.opencontainers.image.description="ADCheck, built using Alpine image with Python 3.14"
LABEL org.opencontainers.image.licenses="MIT license"

RUN addgroup -g 666 appuser && \
    adduser -D -h /home/appuser -u 666 -G appuser appuser

COPY --from=builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

USER appuser

ENTRYPOINT [ "adcheck" ]