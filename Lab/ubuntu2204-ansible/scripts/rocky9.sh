#!/bin/bash
set -euxo pipefail
shopt -s nullglob

# for Japan
timedatectl set-timezone Asia/Tokyo
sed -i.bak '/^server /d' /etc/chrony.conf
echo "server ntp.nict.jp iburst" >> /etc/chrony.conf
systemctl enable --now chronyd
for repo in /etc/yum.repos.d/*.repo; do
  sed -i.bak -E \
    's|(mirrorlist=https://mirrors\.rockylinux\.org/mirrorlist\?[^&]+)&repo=([^&]+)&?|&repo=\2&country=JP&|g' \
    "$repo"
done


dnf -y update
dnf -y upgrade

# for Japanese
#dnf -y install glibc-langpack-ja man-pages-ja man-pages-ja-devel
#localectl set-locale LANG=ja_JP.UTF-8

dnf -y autoremove
dnf -y clean all