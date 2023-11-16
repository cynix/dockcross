#!/usr/bin/env bash
set -x
set -e
set -o pipefail

. "$(dirname "$0")"/freebsd-vars.sh

curl -sSfL https://download.freebsd.org/releases/"$FREEBSD_MACHINE"/"$FREEBSD_VERSION"-RELEASE/base.txz | tar -C "$FREEBSD_SYSROOT"/ -xJf- ./lib ./usr/include ./usr/lib
