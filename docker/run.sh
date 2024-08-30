#!/bin/sh

URL="https://raw.githubusercontent.com/n-Arno/scaleway-kapsule-gvisor/master/config"

wget ${URL}/config.toml -O /k8s-node/config.toml
wget ${URL}/runsc.toml -O /k8s-node/runsc.toml
cp /install-gvisor.sh /k8s-node

/usr/bin/nsenter -m/proc/1/ns/mnt -- chmod u+x /tmp/gvisor/install-gvisor.sh
/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/gvisor/install-gvisor.sh

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Successfully installed gvisor and restarted containerd on node ${NODE_NAME} if needed."

sleep infinity
