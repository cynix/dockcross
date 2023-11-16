#!/usr/bin/env bash
set -x
set -e
set -o pipefail

mkdir -p /usr/local
curl -sSfL https://go.dev/dl/go1.21.4.linux-amd64.tar.gz | tar -C /usr/local/ -xzf-
