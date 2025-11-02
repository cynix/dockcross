#!/usr/bin/env bash
set -x
set -e
set -o pipefail

rustup toolchain install stable
rustup toolchain install nightly --component rust-src

for toolchain in stable nightly; do
  rustup target add --toolchain $toolchain x86_64-unknown-freebsd
done

cargo install bindgen-cli
find /opt/rustup \( -type d -o -type f \) -exec chmod go+w '{}' +
