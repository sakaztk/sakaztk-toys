#!/bin/bash
set -eux pipefail
DEBIAN_FRONTEND=noninteractive

# for Japan
timedatectl set-timezone Asia/Tokyo
echo NTP=ntp.nict.jp >> /etc/systemd/timesyncd.conf
systemctl restart systemd-timesyncd
#sed -i.bak -r 's@http://(jp\.)?archive\.ubuntu\.com/ubuntu/?@https://ftp.udx.icscoe.jp/Linux/ubuntu/@g' /etc/apt/sources.list
sed -i.bak -r 's@mirrors.edge.kernel.org/ubuntu/?@ftp.udx.icscoe.jp/Linux/ubuntu/@g' /etc/apt/sources.list


apt-get update
apt-get upgrade -y
#apt-get dist-upgrade -y

# for Japanese
#apt-get install -y language-pack-ja manpages-ja manpages-ja-dev
#locale-gen ja_JP.UTF-8

apt-get autoremove -y
apt-get autoclean -y