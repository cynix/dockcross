#!/usr/bin/env bash
set -x
set -e
set -o pipefail

mkdir -p /usr/local/zig
curl -sSfL https://ziglang.org/download/0.15.2/zig-$(uname -m)-linux-0.15.2.tar.xz | tar -C /usr/local/zig/ -Jxf- --strip=1
ln -s ../zig/zig /usr/local/bin/zig
