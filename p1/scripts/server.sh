#!/bin/bash

set -eu

echo ">>> Adding agent to /etc/hosts..."
echo "$AGENT_IP $AGENT_HOSTNAME" >> /etc/hosts

# Auto-detect the interface carrying our private IP
FLANNEL_IFACE=$(ip -o -4 addr show | grep "${NODE_IP}" | awk '{print $2}')
echo ">>> Detected flannel interface: ${FLANNEL_IFACE}"

echo ">>> Installing K3s server..."
curl -sfL https://get.k3s.io | sh -s - server \
  --node-ip="${NODE_IP}" \
  --token="${TOKEN}" \
  --tls-san="${NODE_IP}" \
  --flannel-iface="${FLANNEL_IFACE}" \
  --write-kubeconfig-mode 644 \
  --disable=traefik \
  --disable=servicelb \
  --disable=metrics-server

echo ">>> K3s server node '$HOSTNAME' ready (ip: $NODE_IP)."
