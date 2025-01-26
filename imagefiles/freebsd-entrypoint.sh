#!/usr/bin/env bash

if [ -n "$FREEBSD_TARGET" ]; then
  case "$FREEBSD_TARGET" in
    amd64|x86_64)
      export FREEBSD_SYSROOT=/freebsd/amd64
      export FREEBSD_TRIPLE=x86_64-unknown-freebsd
      export RUSTUP_TOOLCHAIN=stable
      ;;
    arm64|aarch64)
      export FREEBSD_SYSROOT=/freebsd/arm64
      export FREEBSD_TRIPLE=aarch64-unknown-freebsd
      export RUSTUP_TOOLCHAIN=nightly
      ;;
    *)
      echo "Unsupported arch: $FREEBSD_TARGET"
      exit 1
      ;;
  esac

  export CFLAGS="--target=$FREEBSD_TRIPLE --sysroot=$FREEBSD_SYSROOT"
  export CXXFLAGS="--target=$FREEBSD_TRIPLE --sysroot=$FREEBSD_SYSROOT -stdlib=libc++"
  export LDFLAGS="--target=$FREEBSD_TRIPLE --sysroot=$FREEBSD_SYSROOT -fuse-ld=lld"

  export PKG_CONFIG_SYSROOT_DIR=$FREEBSD_SYSROOT
  export PKG_CONFIG_PATH=$FREEBSD_SYSROOT/usr/local/libdata/pkgconfig

  export GOARCH=$(basename $FREEBSD_SYSROOT)
  export CGO_CFLAGS="$CFLAGS"
  export CGO_CXXFLAGS="$CXXFLAGS"
  export CGO_LDFLAGS="$LDFLAGS"

  export CARGO_BUILD_TARGET="$FREEBSD_TRIPLE"
  FREEBSD_TRIPLE_ENV=$(echo "$FREEBSD_TRIPLE" | tr - _)
  eval "export CARGO_TARGET_${FREEBSD_TRIPLE_ENV^^}_LINKER=/usr/bin/clang-16"
  eval "export CARGO_TARGET_${FREEBSD_TRIPLE_ENV^^}_RUSTFLAGS=\"-C link-arg=--target=$FREEBSD_TRIPLE -C link-arg=--sysroot=$FREEBSD_SYSROOT -C link-arg=-fuse-ld=lld\""
  eval "export BINDGEN_EXTRA_CLANG_ARGS_$FREEBSD_TRIPLE_ENV=\"--target=$FREEBSD_TRIPLE --sysroot=$FREEBSD_SYSROOT\""
  eval "export ${FREEBSD_TRIPLE_ENV^^}_OPENSSL_DIR=\"$FREEBSD_SYSROOT/usr\""
fi

if [ -n "$FREEBSD_PACKAGES" ]; then
  pkg install $FREEBSD_PACKAGES
fi

if [ -n "$BUILDER_UID" ] && [ -n "$BUILDER_GID" ]; then
  chown -R "$BUILDER_UID":"$BUILDER_GID" /usr/local/cargo /usr/local/rustup
fi

exec /dockcross/entrypoint.sh "$@"
