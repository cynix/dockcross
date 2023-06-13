#!/usr/bin/env bash
set -x
set -e
set -o pipefail

. "$(dirname "$0")"/freebsd-vars.sh

REPO=https://pkg.freebsd.org/FreeBSD:"${FREEBSD_VERSION%.*}":"$FREEBSD_MACHINE_ARCH"/quarterly

mkdir -p /tmp/freebsd-pkg
curl -sSfL "$REPO"/packagesite.txz | tar -C /tmp/freebsd-pkg -xJf-

PACKAGES="sqlite3"

for name in $PACKAGES; do
  path=$(jq -c '. | select ( .name == "'"$name"'" ) | .repopath' /tmp/freebsd-pkg/packagesite.yaml)
  if [[ -z "$path" ]]; then
    echo "FreeBSD package not found: $name"
    exit 1
  fi
  path="${path//'"'/}"

  mkdir /tmp/freebsd-pkg/package
  curl -sSfL "$REPO"/"$path" | tar -C /tmp/freebsd-pkg/package -xJf-
  cp -a /tmp/freebsd-pkg/package/usr/local/* "$FREEBSD_SYSROOT"/
  rm -rf /tmp/freebsd-pkg/package
done

rm -rf /tmp/freebsd-pkg
