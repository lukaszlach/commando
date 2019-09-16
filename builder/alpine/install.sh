#!/usr/bin/env bash
COMMANDS=$1
PACKAGES=
# @todo why can I not make the IFS work here?!
while read COMMAND; do
    APK_FILE=$(/apk-file "bin/$COMMAND" | grep " x86")
    if [ -z "$APK_FILE" ]; then
        echo "Error: Cannot find package for the $COMMAND command"
        exit 1
    fi
    BINARY=$(echo "$APK_FILE" | awk '{print $1}' | sort | uniq | grep -E "/s?bin/${COMMAND}$" | head -n 1)
    if [ ! -z "$BINARY" ]; then
        PACKAGE=$(echo "$APK_FILE" | grep -E "^$BINARY " | awk '{print $2}')
    fi
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
