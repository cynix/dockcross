#!/usr/bin/env bash
set -x
set -e
set -o pipefail

mkdir -p /usr/local
curl -sSfL https://go.dev/dl/go1.23.3.linux-$([ "$(uname -m)" = "x86_64" ] && echo amd64 || echo arm64).tar.gz | tar -C /usr/local/ -xzf-

echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' > /etc/apt/sources.list.d/goreleaser.list
apt-get update --yes \
  && apt-get install --yes goreleaser \
  && apt-get clean autoclean --yes \
  && apt-get autoremove --yes \
  && rm -rf /var/lib/{apt,dpkg,cache,log}
