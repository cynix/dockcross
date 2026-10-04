#!/usr/bin/env bash
set -x
set -e
set -o pipefail

UV_VERSION=0.12.23

curl -sSfL https://github.com/astral-sh/uv/releases/download/$UV_VERSION/uv-$(uname -m)-unknown-linux-gnu.tar.gz | tar -C /usr/local/bin/ --strip-components=1 --no-same-owner -zxf-
