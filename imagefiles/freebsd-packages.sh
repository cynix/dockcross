#!/usr/bin/env bash
set -x
set -e
set -o pipefail

for machine in amd64 arm64; do
  REPO=https://pkg.freebsd.org/FreeBSD:${FREEBSD_VERSION%.*}:${machine/arm64/aarch64}/latest
  PACKAGES="sqlite3"

  curl -sSfL $REPO/packagesite.txz | tar -C /freebsd/$machine/ -xJf- packagesite.yaml
done

pkg install $PACKAGES
