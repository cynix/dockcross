#!/usr/bin/env bash

if [ "$(whoami)" != "root" ]; then
  exec sudo pkg "$@"
fi

export LD_LIBRARY_PATH="/freebsd/pkg/lib:$LD_LIBRARY_PATH"
export OSVERSION=${FREEBSD_VERSION%.*}$(printf '%02d' ${FREEBSD_VERSION#*.})000

for machine in ${FREEBSD_TARGET:-amd64 arm64}; do
  machine=${machine/x86_64/amd64}
  machine=${machine/aarch64/arm64}
  mkdir -p /freebsd/$machine/var/cache/pkg /freebsd/$machine/var/db/pkg

  if [ -z "$FREEBSD_TARGET" ]; then
    echo "===== Running for $machine ====="
  fi
  env ABI=FreeBSD:${FREEBSD_VERSION%.*}:${machine/arm64/aarch64} PKG_CACHEDIR=/freebsd/$machine/var/cache/pkg PKG_DBDIR=/freebsd/$machine/var/db/pkg /freebsd/pkg/sbin/pkg --rootdir /freebsd/$machine --config /freebsd/pkg/etc/pkg.conf --repo-conf-dir /freebsd/pkg/etc/pkg/repos "$@"
  rm -rf /freebsd/$machine/var/cache/pkg
done
