#!/usr/bin/env bash

case "$FREEBSD_ARCH" in
  x86_64)
    FREEBSD_MACHINE=amd64
    FREEBSD_MACHINE_ARCH=amd64
    ;;
  aarch64)
    FREEBSD_MACHINE=arm64
    FREEBSD_MACHINE_ARCH=aarch64
    ;;
  *)
    echo "Unsupported arch: $FREEBSD_ARCH"
    exit 1
    ;;
esac
