#!/bin/bash
set -eux pipefail
DEBIAN_FRONTEND=noninteractive

apt-get install -y \
    slurm-wlm slurm-wlm-basic-plugins munge \
    #openmpi-bin libopenmpi-dev \

# hosts
cat <<EOF >> /etc/hosts
192.168.128.10 slurm-master
192.168.128.11 slurm-node1
192.168.128.12 slurm-node2
EOF

cat <<EOF > /etc/slurm/slurm.conf
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

NodeName=slurm-node[1-2] CPUs=1 State=UNKNOWN
PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP
EOF
