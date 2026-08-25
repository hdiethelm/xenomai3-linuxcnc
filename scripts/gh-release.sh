#! /bin/sh

set -e

. scripts/config.sh

gh release create "$GH_RELEASE_TAG" -d -n "" "$PACKAGE_DIR"/*

