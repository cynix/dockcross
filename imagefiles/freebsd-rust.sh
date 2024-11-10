#!/usr/bin/env bash
set -x
set -e
set -o pipefail

curl -sSfL https://sh.rustup.rs | sh -s -- -y --default-toolchain none --no-modify-path

rustup toolchain install stable
rustup target add --toolchain stable x86_64-unknown-freebsd

rustup toolchain install nightly --component rust-src
