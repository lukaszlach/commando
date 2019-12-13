#!/usr/bin/env bash
COMMANDS=$1
PACKAGES=
# @todo why can I not make the IFS work here?!
while read COMMAND; do
    PACKAGE=$(curl -sSfL "https://command-not-found.com/-/api/package/alpine/$COMMAND")
    if apk info | grep -qE "^${PACKAGE}$" >/dev/null; then
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
apk --no-cache add ${PACKAGES}
exit 0
