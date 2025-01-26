#!/usr/bin/env bash

if [ "$1" != "install" -o -z "$2" ]; then
  echo "Usage: pkg install PKG ..." >&2
  exit 1
fi
shift

if [ "$(whoami)" != "root" ]; then
  exec sudo pkg install "$@"
fi

export LD_LIBRARY_PATH="/freebsd/pkg/lib:$LD_LIBRARY_PATH"
export OSVERSION=${FREEBSD_VERSION%.*}$(printf '%02d' ${FREEBSD_VERSION#*.})000

for machine in ${FREEBSD_TARGET:-amd64 arm64}; do
  machine=${machine/x86_64/amd64}
  machine=${machine/aarch64/arm64}
  mkdir -p /freebsd/$machine/var/cache/pkg /freebsd/$machine/var/db/pkg
  env ABI=FreeBSD:${FREEBSD_VERSION%.*}:${machine/arm64/aarch64} PKG_CACHEDIR=/freebsd/$machine/var/cache/pkg PKG_DBDIR=/freebsd/$machine/var/db/pkg /freebsd/pkg/sbin/pkg --rootdir /freebsd/$machine --config /freebsd/pkg/etc/pkg.conf --repo-conf-dir /freebsd/pkg/etc/pkg/repos install --no-scripts --yes "$@"
done
