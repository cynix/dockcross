#!/usr/bin/env bash
set -x
set -e
set -o pipefail

rustup toolchain install stable
rustup toolchain install nightly --component rust-src

for toolchain in stable nightly; do
  rustup target add --toolchain $toolchain x86_64-unknown-freebsd
done

mkdir -m777 /opt/rustup/cargo/git /opt/rustup/cargo/registry
