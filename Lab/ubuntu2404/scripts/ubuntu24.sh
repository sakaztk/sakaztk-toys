#!/bin/bash
set -eux pipefail
DEBIAN_FRONTEND=noninteractive

# for Japan
timedatectl set-timezone Asia/Tokyo
echo NTP=ntp.nict.jp >> /etc/systemd/timesyncd.conf
systemctl restart systemd-timesyncd
sed -i.bak -r 's@http://(jp\.)?archive\.ubuntu\.com/ubuntu/?@https://ftp.udx.icscoe.jp/Linux/ubuntu/@g' /etc/apt/sources.list
#sed -i.bak -r 's@mirrors.edge.kernel.org/ubuntu/?@ftp.udx.icscoe.jp/Linux/ubuntu/@g' /etc/apt/sources.list


apt-get update
apt-get upgrade -y
#apt-get dist-upgrade -y
apt-get install -y ubuntu-server
apt-get install -y \
    acl adduser apt-utils bash bsdmainutils coreutils curl dash \
    dnsutils e2fslibs e2fsprogs fdisk findutils grep gzip hostname \
    ifupdown init-system-helpers iproute2 iputils-ping less \
    login lsb-release man-db mawk mount ncurses-base ncurses-bin \
    netcat-openbsd net-tools passwd perl-base sed sensible-utils \
    sysvinit-utils tar tzdata util-linux vim-tiny wget


# for Japanese
apt-get install -y language-pack-ja manpages-ja manpages-ja-dev
locale-gen ja_JP.UTF-8
   
apt-get autoremove -y
apt-get autoclean -y