#!/bin/bash
set -euo pipefail
DEBIAN_FRONTEND=noninteractive

TARGET_RELEASE='5.0'
USE_SLURM=1

apt-get update
apt-get install -y build-essential wget libtool autoconf automake pkg-config
if [ "$USE_SLURM" -eq 1 ]; then
  apt-get install -y libslurm-dev
fi

# Download
VERSION=$(curl -s -A "Mozilla/5.0" https://www.open-mpi.org/software/ompi/v$TARGET_RELEASE/ \
  | grep -oP 'openmpi-\K[0-9]+\.[0-9]+\.[0-9]+(?=\.tar\.gz)' \
  | sort -V \
  | tail -1)
echo "Latest OpenMPI version in v$TARGET_RELEASE series: $VERSION"
URL="https://download.open-mpi.org/release/open-mpi/v$TARGET_RELEASE/openmpi-${VERSION}.tar.gz"
echo "Downloading Open MPI from $URL ..."
wget -q --show-progress "$URL" -O /tmp/openmpi-${VERSION}.tar.gz

# Install
cd /tmp
tar xf openmpi-${VERSION}.tar.gz
cd openmpi-${VERSION}

CONFIG_OPTS="--prefix=/usr/local/openmpi"
if [ "$USE_SLURM" -eq 1 ]; then
  CONFIG_OPTS+=" --with-slurm"
fi

./configure $CONFIG_OPTS
make -j$(nproc)
make install

cat <<'EOF' > /etc/profile.d/openmpi.sh
export PATH=/usr/local/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/openmpi/lib:${LD_LIBRARY_PATH:-}
EOF
chmod 644 /etc/profile.d/openmpi.sh
grep -qxF 'source /etc/profile.d/openmpi.sh' /home/vagrant/.bashrc || echo 'source /etc/profile.d/openmpi.sh' >> /home/vagrant/.bashrc
chown vagrant:vagrant /home/vagrant/.bashrc
if grep -q '^PATH=' /etc/environment; then
  sed -i "s|^PATH=\"\(.*\)\"|PATH=\"/usr/local/openmpi/bin:\1\"|" /etc/environment
fi


echo "/usr/local/openmpi/lib" > /etc/ld.so.conf.d/openmpi.conf
ldconfig

cd ~
rm -rf /tmp/openmpi-*

echo "Open MPI $VERSION installed successfully."
