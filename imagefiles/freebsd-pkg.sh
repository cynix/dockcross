#!/usr/bin/env bash

if [ "$1" != "install" -o -z "$2" ]; then
  echo "Usage: pkg install PKG ..." >&2
  exit 1
fi
shift

if [ "$(whoami)" != "root" ]; then
  exec sudo pkg install "$@"
fi

for machine in amd64 arm64; do
  REPO=https://pkg.freebsd.org/FreeBSD:${FREEBSD_VERSION%.*}:${machine/arm64/aarch64}/latest

  for name in "$@"; do
    path=$(jq -r '. | select ( .name == "'$name'" ) | .repopath' /freebsd/$machine/packagesite.yaml)
    if [ -z "$path" ]; then
      echo "FreeBSD $machine package not found: $name" >&2
      exit 1
    fi

    curl -sSfL $REPO/$path | tar -C /freebsd/$machine/ --zstd -xvf- /usr/local/
  done
done
