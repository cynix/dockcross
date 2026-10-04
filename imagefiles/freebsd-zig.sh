#!/usr/bin/env bash
set -x
set -e
set -o pipefail

ZIG_VERSION=0.17.0

mkdir -p /usr/local/zig
curl -sSfL https://ziglang.org/download/$ZIG_VERSION/zig-$(uname -m)-linux-$ZIG_VERSION.tar.xz | tar -C /usr/local/zig/ -Jxf- --strip=1
ln -s ../zig/zig /usr/local/bin/zig
