#!/usr/bin/env bash
set -x
set -e
set -o pipefail

export CARGO_HOME=/usr/local/cargo
export RUSTUP_HOME=/usr/local/rustup

curl -sSfL https://sh.rustup.rs -o /tmp/rustup-init.sh

if [ "$RUSTUP_TOOLCHAIN" = "nightly" ]; then
  sh /tmp/rustup-init.sh -y --no-modify-path --default-toolchain nightly --no-update-default-toolchain --component rust-src
else
  sh /tmp/rustup-init.sh -y --no-modify-path --default-toolchain stable --no-update-default-toolchain --target "$FREEBSD_TRIPLE"
fi

rm /tmp/rustup-init.sh
