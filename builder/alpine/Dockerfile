# Pick the newest Alpine version
FROM alpine AS release
CMD ["/bin/bash"]
RUN apk --no-cache add bash curl
COPY install.sh /
#RUN bash /install.sh "$COMMANDS"
