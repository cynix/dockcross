#!/usr/bin/env bash

case "$FREEBSD_ARCH" in
  x86_64)
    export GOARCH=amd64
    ;;
  aarch64)
    export GOARCH=arm64
    ;;
  *)
    echo "Unsupported arch: $FREEBSD_ARCH"
    exit 1
    ;;
esac

FREEBSD_TRIPLE_ENV=$(echo "${FREEBSD_TRIPLE}" | tr - _)

eval "export CARGO_TARGET_${FREEBSD_TRIPLE_ENV^^}_LINKER=/usr/bin/clang-13"
eval "export CARGO_TARGET_${FREEBSD_TRIPLE_ENV^^}_RUSTFLAGS=\"-C relocation-model=static -C link-arg=--target=${FREEBSD_TRIPLE} -C link-arg=--sysroot=${FREEBSD_SYSROOT} -C link-arg=-fuse-ld=lld\""
eval "export BINDGEN_EXTRA_CLANG_ARGS_${FREEBSD_TRIPLE_ENV}=\"--target=${FREEBSD_TRIPLE} --sysroot=${FREEBSD_SYSROOT}\""

export CARGO_BUILD_TARGET="$FREEBSD_TRIPLE"
eval "export ${FREEBSD_TRIPLE_ENV^^}_OPENSSL_DIR=\"${FREEBSD_SYSROOT}/usr\""

if [ -n "$BUILDER_UID" ] && [ -n "$BUILDER_GID" ]; then
  chown -R "$BUILDER_UID":"$BUILDER_GID" /usr/local/cargo /usr/local/rustup
fi

exec /dockcross/entrypoint.sh "$@"
