#!/usr/bin/env bash
set -x
set -e
set -o pipefail

. "$(dirname "$0")"/freebsd-vars.sh

#mkdir -p /tmp/freebsd
curl -sSfL https://download.freebsd.org/releases/"$FREEBSD_MACHINE"/"$FREEBSD_VERSION"-RELEASE/base.txz | tar -C "$FREEBSD_SYSROOT"/ -xJf- ./lib ./usr/include ./usr/lib
#
#mkdir -p "$FREEBSD_SYSROOT"/lib
#cp -a /tmp/freebsd/include "$FREEBSD_SYSROOT"/
#cp -a /tmp/freebsd/lib/* "$FREEBSD_SYSROOT"/lib/
#cp -a /tmp/freebsd/usr/lib/lib{c,c++,compiler_rt,cxxrt,kvm,m,memstat,ssp_nonshared,util}.a "$FREEBSD_SYSROOT"/lib/
#cp -a /tmp/freebsd/usr/lib/lib{c++,execinfo,procstat,rt}.so.1 "$FREEBSD_SYSROOT"/lib/
#cp -a /tmp/freebsd/usr/lib/libmemstat.so.3 "$FREEBSD_SYSROOT"/lib/
#cp -a /tmp/freebsd/usr/lib/{crt1,Scrt1,crti,crtn}.o "$FREEBSD_SYSROOT"/lib/
#rm -rf /tmp/freebsd
#
#for lib in "$FREEBSD_SYSROOT"/lib/*.so.*; do
#  base=$(basename "$lib")
#  link="$base"
#
#  while [[ "$link" == *.so.* ]]; do
#    link=${link%.*}
#  done
#
#  if [[ -n "$link" ]] && [[ "$link" != "$base" ]] && [[ ! -f /freebsd/lib/"$link" ]]; then
#    ln -s "$base" "$FREEBSD_SYSROOT"/lib/"$link"
#  fi
#done
#
#ln -s libthr.so.3 "$FREEBSD_SYSROOT"/lib/libpthread.so
