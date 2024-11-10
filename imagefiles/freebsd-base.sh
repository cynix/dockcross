#!/usr/bin/env bash
set -x
set -e
set -o pipefail

for machine in amd64 arm64; do
  mkdir -p /freebsd/$machine
  curl -sSfL https://download.freebsd.org/releases/$machine/$FREEBSD_VERSION-RELEASE/base.txz | tar -C /freebsd/$machine/ -xJf- ./lib ./usr/include ./usr/lib
done
