#!/usr/bin/env bash

if [ -n "$FREEBSD_ARCH" ]; then
  case "$FREEBSD_ARCH" in
    amd64|x86_64)
      export FREEBSD_ARCH=amd64
      export FREEBSD_SYSROOT=/freebsd/amd64
      export FREEBSD_TRIPLE=x86_64-unknown-freebsd
      export GOARCH=amd64
      ;;
    arm64|aarch64)
      export FREEBSD_ARCH=aarch64
      export FREEBSD_SYSROOT=/freebsd/aarch64
      export FREEBSD_TRIPLE=aarch64-unknown-freebsd
      export GOARCH=arm64
      ;;
    *)
      echo "Unsupported arch: $FREEBSD_ARCH"
      exit 1
      ;;
  esac

  export CGO_CFLAGS="--target=$FREEBSD_TRIPLE --sysroot=$FREEBSD_SYSROOT"
  export CGO_CXXFLAGS="$CGO_CFLAGS -stdlib=libc++"
  export CGO_LDFLAGS="$CGO_CFLAGS -fuse-ld=lld"

  export CARGO_BUILD_TARGET="$FREEBSD_TRIPLE"
fi

if [ -n "$FREEBSD_PACKAGES" ]; then
  pkg install $FREEBSD_PACKAGES
fi

exec /dockcross/entrypoint.sh "$@"
