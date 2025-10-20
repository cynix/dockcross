#!/usr/bin/env bash
set -x
set -e
set -o pipefail

curl -sSfL https://github.com/astral-sh/uv/releases/download/0.9.4/uv-$(uname -m)-unknown-linux-gnu.tar.gz | tar -C /usr/local/bin/ --strip-components=1 --no-same-owner -zxf-
