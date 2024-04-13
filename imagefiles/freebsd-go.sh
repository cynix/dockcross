#!/usr/bin/env bash
set -x
set -e
set -o pipefail

mkdir -p /usr/local
curl -sSfL https://go.dev/dl/go1.22.2.linux-$([ "$(uname -m)" = "x86_64" ] && echo amd64 || echo arm64).tar.gz | tar -C /usr/local/ -xzf-
