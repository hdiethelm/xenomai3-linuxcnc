#! /bin/bash
set -e

. scripts/config.sh

REPO="hdiethelm/xenomai3-linuxcnc"
TAG="$GH_RELEASE_TAG"
DEST="$PACKAGE_DIR"

command -v curl >/dev/null 2>&1 || {
    echo "Error: curl is required. To install, run: sudo apt install curl" >&2
    exit 1
}

command -v jq >/dev/null 2>&1 || {
    echo "Error: jq is required. To install, run: sudo apt install jq" >&2
    exit 1
}

API_URL="https://api.github.com/repos/${REPO}/releases/tags/${TAG}"

mkdir -p "$DEST"
cd "$DEST"

echo "Fetching release information..."
ASSETS=$(curl -fsSL \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "$API_URL" |
    jq -r '.assets[] | [.name, .browser_download_url, .digest] | @tsv')

if [[ -z "$ASSETS" ]]; then
    echo "Error: no release assets found." >&2
    exit 1
fi

COUNT=0

while IFS=$'\t' read -r NAME URL DIGEST; do
    [[ -z "$NAME" ]] && continue

    DIGEST_CMD="${DIGEST//sha256:/} $NAME"

    if echo "$DIGEST_CMD" | sha256sum -c &> /dev/null ; then
        echo "Already downloaded: $NAME"
    else
        rm -f "$NAME"
        echo "Downloading: $NAME"
        curl -fL \
            --retry 3 \
            --retry-delay 2 \
            -C - \
            -o "$NAME" \
            "$URL"

        if echo "$DIGEST_CMD" | sha256sum -c &> /dev/null ; then
            echo "Checksum ok: $NAME"
        else
            echo "Checksum fail: $NAME"
            rm "$NAME"
        fi
    fi

    ((COUNT += 1))
done <<< "$ASSETS"

echo
echo "Downloaded $COUNT release assets to:"
echo "  $(pwd)"
