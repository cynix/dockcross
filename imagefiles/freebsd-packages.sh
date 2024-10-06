#!/usr/bin/env bash
set -x
set -e
set -o pipefail

REPO=https://pkg.freebsd.org/FreeBSD:"${FREEBSD_VERSION%.*}":"$FREEBSD_MACHINE_ARCH"/quarterly
PACKAGES="sqlite3"

curl -sSfL "$REPO"/packagesite.txz | tar -C /usr/local/etc/ -xJf- packagesite.yaml
pkg install $PACKAGES
