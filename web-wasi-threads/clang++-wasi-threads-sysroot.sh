#!/usr/bin/env sh

exec ${WASI_SDK_PATH}/bin/clang++ -pthread --target=wasm32-wasi-threads --sysroot=${WASI_SYSROOT} "$@"
