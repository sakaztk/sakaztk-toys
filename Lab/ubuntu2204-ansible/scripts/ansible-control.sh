#!/bin/bash
set -eux pipefail
DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible
