#!/bin/sh
set -eu

: "${FREEBSD_SYSROOT:?FREEBSD_SYSROOT is not set}"

export PKG_CONFIG_LIBDIR="$FREEBSD_SYSROOT/usr/libdata/pkgconfig:$FREEBSD_SYSROOT/usr/local/libdata/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="$FREEBSD_SYSROOT"
export PKG_CONFIG_PATH=

exec /usr/bin/pkg-config "$@"
