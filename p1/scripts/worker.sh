#!/bin/bash

set -eu

echo ">>> Adding server to /etc/hosts..."
echo "$SERVER_IP $SERVER_HOSTNAME" >> /etc/hosts

# Auto-detect the interface carrying our private IP
FLANNEL_IFACE=$(ip -o -4 addr show | grep "${NODE_IP}" | awk '{print $2}')
echo ">>> Detected flannel interface: ${FLANNEL_IFACE}"

echo ">>> Waiting for K3s server API..."
while ! curl -sk --connect-timeout 2 https://${SERVER_IP}:6443 >/dev/null 2>&1; do
  echo "    Waiting for ${SERVER_IP}:6443..."
  sleep 3
done
echo ">>> Server API is reachable."

echo ">>> Installing K3s agent..."
curl -sfL https://get.k3s.io | sh -s - agent \
  --server=https://${SERVER_IP}:6443 \
  --node-ip="${NODE_IP}" \
  --token="${TOKEN}" \
  --flannel-iface="${FLANNEL_IFACE}"

echo ">>> K3s agent node '$HOSTNAME' ready (ip: $NODE_IP)."
