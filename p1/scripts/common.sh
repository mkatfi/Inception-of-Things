#!/bin/bash

set -e

echo ">>> Installing prerequisites..."
apt-get update -qq
apt-get install -y -qq curl

echo ">>> Disabling swap (K3s requirement)..."
swapoff -a
sed -i '/swap/d' /etc/fstab

echo ">>> Setting up shell aliases..."
echo "alias k='kubectl'" >> /home/vagrant/.bashrc

echo ">>> Common setup done."
