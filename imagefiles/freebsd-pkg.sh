#!/usr/bin/env bash

if [ "$(whoami)" != "root" ]; then
  exec sudo pkg "$@"
fi

export LD_LIBRARY_PATH="/freebsd/pkg/lib:$LD_LIBRARY_PATH"
export OSVERSION=${FREEBSD_VERSION%.*}$(printf '%02d' ${FREEBSD_VERSION#*.})000

for arch in ${FREEBSD_ARCH:-amd64 aarch64}; do
  mkdir -p /freebsd/$arch/var/cache/pkg /freebsd/$arch/var/db/pkg

  if [ -z "$FREEBSD_ARCH" ]; then
    echo "===== Running for $arch ====="
  fi
  env ABI=FreeBSD:${FREEBSD_VERSION%.*}:$arch PKG_CACHEDIR=/freebsd/$arch/var/cache/pkg PKG_DBDIR=/freebsd/$arch/var/db/pkg /freebsd/pkg/sbin/pkg --rootdir /freebsd/$arch --config /freebsd/pkg/etc/pkg.conf --repo-conf-dir /freebsd/pkg/etc/pkg/repos "$@"
  rm -rf /freebsd/$arch/var/cache/pkg
done
