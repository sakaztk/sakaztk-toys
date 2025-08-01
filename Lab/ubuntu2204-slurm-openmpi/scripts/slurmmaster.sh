#!/bin/bash
set -eux pipefail
DEBIAN_FRONTEND=noninteractive

SLURM_VERSION=24.11.6

# https://slurm.schedmd.com/quickstart_admin.html#prereqs
apt-get update
apt-get install -y \
  build-essential \
  freeipmi \
  libibmad-dev libibumad-dev \
  libhdf5-dev \
  libmysqlclient-dev mariadb-server \
  libjwt-dev \
  munge libmunge-dev \
  man2html \
  lua5.3 liblua5.3-dev \
  libpam0g-dev \
  libpmix-dev \
  libreadline-dev \
  libhttp-parser-dev libjson-c-dev libyaml-dev \
  libgtk2.0-dev \
  curl \
  libnuma-dev \
  libhwloc-dev linux-libc-dev libdbus-1-dev

# hosts
cat <<'EOF' >> /etc/hosts
192.168.128.10 slurm-master
192.168.128.11 slurm-node1
192.168.128.12 slurm-node2
EOF

# munge
dd if=/dev/urandom bs=1 count=1024 of=/etc/munge/munge.key
chown munge:munge /etc/munge/munge.key
chmod 400 /etc/munge/munge.key
systemctl enable munge --now

# Slurm
cd /usr/local/src
curl -O https://download.schedmd.com/slurm/slurm-${SLURM_VERSION}.tar.bz2
tar -xjf slurm-${SLURM_VERSION}.tar.bz2
cd slurm-${SLURM_VERSION}

./configure --prefix=/opt/slurm \
            --sysconfdir=/etc/slurm \
            --with-munge \
            --with-hwloc \
            --with-numa
make -j$(nproc)
make install

useradd -r -c "Slurm user" -s /bin/false slurm || true
mkdir -p /var/spool/slurmctld /var/spool/slurmd /var/log/slurm
chown slurm:slurm /var/spool/slurmctld /var/spool/slurmd /var/log/slurm

## slurm.conf
mkdir -p /etc/slurm
cat <<'EOF' > /etc/slurm/slurm.conf
ClusterName=slurm-test
ControlMachine=slurm-master
SlurmUser=slurm
SlurmdSpoolDir=/var/spool/slurmd
StateSaveLocation=/var/spool/slurmctld
SwitchType=switch/none
MpiDefault=none
ProctrackType=proctrack/pgid
TaskPlugin=task/none
ReturnToService=2
SlurmctldPidFile=/var/run/slurmctld.pid
SlurmdPidFile=/var/run/slurmd.pid

NodeName=slurm-master CPUs=1 State=UNKNOWN
NodeName=slurm-node1 CPUs=1 State=UNKNOWN
NodeName=slurm-node2 CPUs=1 State=UNKNOWN
PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP
EOF

## systemd
cat <<'EOF' > /etc/systemd/system/slurmctld.service
[Unit]
Description=Slurm controller daemon
After=munge.service network.target

[Service]
Type=simple
User=slurm
ExecStart=/opt/slurm/sbin/slurmctld -D
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

cat <<'EOF' > /etc/systemd/system/slurmd.service
[Unit]
Description=Slurm node daemon
After=munge.service network.target

[Service]
Type=simple
User=root
ExecStart=/opt/slurm/sbin/slurmd -D
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now slurmctld slurmd

cat <<'EOF' > /etc/profile.d/slurm.sh
export PATH=/opt/slurm/bin:$PATH
export LD_LIBRARY_PATH=/opt/slurm/lib:${LD_LIBRARY_PATH:-}
EOF
chmod 644 /etc/profile.d/slurm.sh
grep -qxF 'source /etc/profile.d/slurm.sh' /home/vagrant/.bashrc || echo 'source /etc/profile.d/slurm.sh' >> /home/vagrant/.bashrc
chown vagrant:vagrant /home/vagrant/.bashrc
if grep -q '^PATH=' /etc/environment; then
  sed -i "s|^PATH=\"\(.*\)\"|PATH=\"/opt/slurm/bin:\1\"|" /etc/environment
fi
