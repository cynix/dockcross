#!/usr/bin/env bash

if [ "$1" != "install" -o -z "$2" ]; then
  echo "Usage: pkg install PKG ..." >&2
  exit 1
fi
shift

if [ "$(whoami)" != "root" ]; then
  exec sudo pkg install "$@"
fi

REPO=https://pkg.freebsd.org/FreeBSD:"${FREEBSD_VERSION%.*}":"$FREEBSD_MACHINE_ARCH"/quarterly

for name in "$@"; do
  path=$(jq -r '. | select ( .name == "'"$name"'" ) | .repopath' /usr/local/etc/packagesite.yaml)
  if [ -z "$path" ]; then
    echo "FreeBSD package not found: $name" >&2
    exit 1
  fi

  curl -sSfL "$REPO"/"$path" | tar -C "$FREEBSD_SYSROOT"/ --zstd -xvf- /usr/local/
done
