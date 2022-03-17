#!/usr/bin/env bash
COMMANDS=$1
PACKAGES=
# @todo why can I not make the IFS work here?!
apk update
while read COMMAND; do
    PACKAGE=$(curl -sSfL "https://command-not-found.com/-/api/package/alpine/$COMMAND")
    if [ -z "${PACKAGE}" ] && apk info ${COMMAND} 1>&2 2>/dev/null; then
      PACKAGE=${COMMAND}
    fi

    if [ -n "${PACKAGE}" ] && apk info | grep -qE "^${PACKAGE}$" >/dev/null; then
        echo "Notice: Package already installed"
        exit 0
    fi
    if [ ! -z "$PACKAGE" ]; then
        PACKAGES="${PACKAGES}${PACKAGE} "
    fi
done < <(echo "$COMMANDS" | tr ' ' $'\n')
if [ -z "$PACKAGES" ]; then
    echo "Error: Nothing to install"
    exit 1
fi
apk add ${PACKAGES}
rm -rf /var/cache/apk/*
exit 0
