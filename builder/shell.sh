#!/usr/bin/env bash
URL="$1"
if curl -sSf -m 1 -I "registry:5000$URL"; then
    # Image already exists in the registry
    exit 0
fi
set -e
TARGET_IMAGE=$(echo "$URL" | sed 's|^/v2/||; s|/manifests/latest$||')
PARAMS=$(echo "$TARGET_IMAGE" | sed 's|^/v2/||; s|/manifests/latest$||' | tr '/' ' ')
set -- $PARAMS
COMMANDS=$(printf '%s\n' "$@" | sort)
if [ -z "$COMMANDS" ]; then
    echo "Error: No commands specified"
    exit 1
fi
image_tag () {
    echo "$BUILDER_BASE_IMAGE $@" | xargs | md5sum | awk '{print $1}'
}
IMAGE_TAG=$(image_tag "$COMMANDS")
TEMP_DOCKERFILE="/tmp/Dockerfile.$IMAGE_TAG"
cp -f "/builder/$BUILDER_BASE_IMAGE/Dockerfile" "$TEMP_DOCKERFILE"
while read COMMAND; do
    SANITIZED_COMMAND=$(echo "$COMMAND" | sed 's/[^a-zA-Z0-9._~-]//g')
    if [ "$SANITIZED_COMMAND" != "$COMMAND" ]; then
        echo "Error: $COMMAND contains invalid characters (sanitized to $SANITIZED_COMMAND)"
        exit 1
    fi
    echo "RUN bash /install.sh $COMMAND" >> "$TEMP_DOCKERFILE"
done <<< $COMMANDS
docker build -q \
    --force-rm \
    --build-arg "COMMANDS=$COMMANDS" \
    -t "$IMAGE_TAG" \
    -f "$TEMP_DOCKERFILE" \
    "/builder/$BUILDER_BASE_IMAGE"
rm -f "$TEMP_DOCKERFILE"
docker tag "$IMAGE_TAG" "registry:5000/$TARGET_IMAGE"
if [ ! -z "$BUILDER_REGISTRY_USERNAME" ] && [ ! -z "$BUILDER_REGISTRY_PASSWORD" ]; then
echo "$BUILDER_REGISTRY_PASSWORD" | \
    docker login --username "$BUILDER_REGISTRY_USERNAME" --password-stdin "registry:5000"
fi
docker push "registry:5000/$TARGET_IMAGE"
exit 0
