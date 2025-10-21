#!/usr/bin/env bash
set -x
set -e
set -o pipefail

mkdir -p /freebsd/work/build /freebsd/pkg/etc/pkg/repos /freebsd/pkg/keys/trusted

cat > /freebsd/pkg/etc/pkg/repos/FreeBSD.conf <<EOF
FreeBSD: {
  url: "pkg+http://pkg.FreeBSD.org/\${ABI}/latest",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "../pkg/keys",
  enabled: yes
}
FreeBSD-base: {
  url: "pkg+http://pkg.FreeBSD.org/\${ABI}/base_release_${FREEBSD_VERSION#*.}",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "../pkg/keys",
  enabled: yes
}
EOF

cat > /freebsd/pkg/keys/trusted/pkg.freebsd.org.2013102301 <<'EOF'
function: "sha256"
fingerprint: "b0170035af3acc5f3f3ae1859dc717101b4e6c1d0a794ad554928ca0cbb2f438"
EOF

apt-get install -y build-essential libacl1-dev libarchive-dev libarchive-tools libattr1-dev libbsd-dev libbz2-dev liblua5.2-dev liblzma-dev liblzo2-dev libsqlite3-dev libssl-dev m4 pkg-config python3 zlib1g-dev
git clone --branch=2.3.1 --depth=1 https://github.com/freebsd/pkg.git /freebsd/work/pkg

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

for arch in amd64 arm64; do
  env FREEBSD_TARGET=$arch pkg install FreeBSD-mtree FreeBSD-runtime FreeBSD-zoneinfo $(env FREEBSD_TARGET=$arch pkg search --repo FreeBSD-base --quiet --glob 'FreeBSD-*lib*' | egrep -v -- '-(dbg|lib32|man)-') $(env FREEBSD_TARGET=$arch pkg search --repo FreeBSD-base --quiet --glob 'FreeBSD-*-dev-*' | egrep -v -- '-(dbg|lib32|man)-')
done
