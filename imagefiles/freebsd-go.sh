#!/usr/bin/env bash
set -x
set -e
set -o pipefail

mkdir -p /usr/local
curl -sSfL https://go.dev/dl/go1.20.5.linux-amd64.tar.gz | tar -C /usr/local/ -xzf-
