FROM golang:1.13-alpine AS builder
WORKDIR /builder
ENV GOPATH=/builder
COPY ./builder /builder
RUN go build .

FROM alpine:3.10 AS docker
ARG DOCKER_CLI_VERSION=19.03.1
RUN apk --update add curl && \
    mkdir /docker && \
    curl -sSfL "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION.tgz" | tar -xz -C /docker && \
    mv /docker/docker/docker /usr/local/bin/ && \
    rm -rf /docker && \
    docker --help

FROM alpine:3.10 AS release
EXPOSE 5050/tcp
ENV BUILDER_BASE_IMAGE=alpine
CMD ["builder"]
RUN apk --no-cache add curl bash
COPY --from=builder /builder/builder /usr/local/bin/
COPY --from=docker /usr/local/bin/docker /usr/local/bin/
COPY ./builder /builder
