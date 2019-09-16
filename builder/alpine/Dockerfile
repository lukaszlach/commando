# This stage is built once on the first hit and cached afterwards
FROM alpine:3.10 AS dependencies
ARG APK_FILE_VERSION=0.3.5
RUN apk --no-cache add curl && \
    curl -sSfL https://github.com/genuinetools/apk-file/releases/download/v${APK_FILE_VERSION}/apk-file-linux-amd64 -o /apk-file && \
    export APK_FILE_SHA256="6cbd92aea6448b0f526d76e1a910b97799bbcba9bed99a6049d0b80a03e2295c" && \
    echo "$APK_FILE_SHA256  /apk-file" | sha256sum -c - && \
    chmod a+x /apk-file
COPY ./install.sh /

# Pick the newest Alpine version
FROM alpine AS release
CMD ["/bin/bash"]
RUN apk --no-cache add bash ca-certificates
COPY --from=dependencies /install.sh /apk-file /
#RUN bash /install.sh "$COMMANDS"
