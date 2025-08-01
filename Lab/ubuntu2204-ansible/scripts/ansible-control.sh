#!/bin/bash
set -eux pipefail
DEBIAN_FRONTEND=noninteractive

sudo apt-get update

sudo apt-get install -y \
  python3 \
  python3-venv \
  python3-pip \
  git \
  docker.io \
  docker-compose \
  graphviz

python3 -m venv /opt/ansible-env
source /opt/ansible-env/bin/activate
pip install --upgrade pip

pip install \
  ansible \
  ansible-core \
  ansible-lint \
  ansible-runner \
  ansible-navigator \
  ansible-autodoc \
  molecule \
  molecule-docker \
  molecule-plugins \
  pytest \
  testinfra \
  pytest-testinfra \
  sops \
  yamllint \
#  ansible-sops \

chown -R vagrant:vagrant /opt/ansible-env
usermod -aG docker vagrant
sudo systemctl enable --now docker
