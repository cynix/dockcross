#!/usr/bin/env bash
set -x
set -e
set -o pipefail

FREEBSD_VERSION_MAJOR=${FREEBSD_VERSION%.*}
FREEBSD_VERSION_MINOR=${FREEBSD_VERSION#*.}

mkdir -p /freebsd/work/build /freebsd/pkg/etc/pkg/repos /freebsd/pkg/keys/pkg/trusted /freebsd/pkg/keys/pkgbase-${FREEBSD_VERSION_MAJOR}/trusted

cat > /freebsd/pkg/etc/pkg/repos/FreeBSD.conf <<EOF
FreeBSD-ports: {
  url: "pkg+http://pkg.FreeBSD.org/\${ABI}/latest",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "../pkg/keys/pkg",
  enabled: yes
}
FreeBSD-base: {
  url: "pkg+http://pkg.FreeBSD.org/\${ABI}/base_release_${FREEBSD_VERSION_MINOR}",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "../pkg/keys/pkgbase-${FREEBSD_VERSION_MAJOR}",
  enabled: yes
}
EOF

cat > /freebsd/pkg/keys/pkg/trusted/pkg.freebsd.org.2013102301 <<'EOF'
function: "sha256"
fingerprint: "b0170035af3acc5f3f3ae1859dc717101b4e6c1d0a794ad554928ca0cbb2f438"
EOF
cat > /freebsd/pkg/keys/pkgbase-${FREEBSD_VERSION_MAJOR}/trusted/awskms-${FREEBSD_VERSION_MAJOR} <<'EOF'
function: "sha256"
fingerprint: "1d7b45d20fa8d6ed26f9b4a13ac81a6b5df860b9fe644d07b87e92298ba72595"
EOF
cat > /freebsd/pkg/keys/pkgbase-${FREEBSD_VERSION_MAJOR}/trusted/backup-signing-${FREEBSD_VERSION_MAJOR} <<'EOF'
function: "sha256"
fingerprint: "56a77bdcb6c3cf7984729c6138bd5617c24aa0d466b3b604c96205b2c5629f3c"
EOF

apt-get install -y build-essential libacl1-dev libarchive-dev libarchive-tools libattr1-dev libbsd-dev libbz2-dev liblua5.2-dev liblzma-dev liblzo2-dev libsqlite3-dev libssl-dev m4 pkg-config python3 zlib1g-dev
git clone --branch=2.6.2 --depth=1 https://github.com/freebsd/pkg.git /freebsd/work/pkg

cd /freebsd/work/build
../pkg/configure --prefix=/freebsd/pkg
make -j4
make install

mv /freebsd/pkg/etc/pkg.conf.sample /freebsd/pkg/etc/pkg.conf
cat >> /freebsd/pkg/etc/pkg.conf <<'EOF'
ASSUME_ALWAYS_YES = true;
RUN_SCRIPTS = false;
EOF

cd /freebsd
rm -rf /freebsd/work

for arch in amd64 aarch64; do
  env FREEBSD_ARCH=$arch pkg install FreeBSD-mtree FreeBSD-runtime FreeBSD-zoneinfo $(env FREEBSD_ARCH=$arch pkg search --repo FreeBSD-base --quiet --glob 'FreeBSD-*lib*' | egrep -v -- '-(dbg|lib32|man)-') $(env FREEBSD_ARCH=$arch pkg search --repo FreeBSD-base --quiet --glob 'FreeBSD-*-dev-*' | egrep -v -- '-(dbg|lib32|man)-')
done
