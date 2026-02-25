#!/bin/bash
set -e

if [ -z "${NODE_IP:-}" ]; then
  echo "NODE_IP not set"
  exit 1
fi

echo " Installing dependencies..."
apt-get update -qq && apt-get install -y -qq curl >/dev/null

echo "🚀 Installing K3s..."

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --node-ip=${NODE_IP} \
  --write-kubeconfig-mode=644" sh -


# Useful alias
echo "alias k='kubectl'" >> /home/vagrant/.bashrc

# Host entries for internal testing
echo "${NODE_IP} app1.com" >> /etc/hosts
echo "${NODE_IP} app2.com" >> /etc/hosts
echo "${NODE_IP} app3.com" >> /etc/hosts

echo "✅ >>>> K3s installed"
