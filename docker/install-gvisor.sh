#!/bin/bash

NEED_RESTART=0

Install() {
  # From official installation procedure https://gvisor.dev/docs/user_guide/install/
  echo "Installation gVisor binaries"
  (
    set -e
    ARCH=$(uname -m)
    URL=https://storage.googleapis.com/gvisor/releases/release/latest/${ARCH}
    wget ${URL}/runsc ${URL}/runsc.sha512 \
      ${URL}/containerd-shim-runsc-v1 ${URL}/containerd-shim-runsc-v1.sha512
    sha512sum -c runsc.sha512 \
      -c containerd-shim-runsc-v1.sha512
    rm -f *.sha512
    chmod a+rx runsc containerd-shim-runsc-v1
    sudo mv runsc containerd-shim-runsc-v1 /usr/local/bin
    NEED_RESTART=1
  )
}

Config() {
  echo "Configuring containerd"
  # Backup only if no backup already exists
  [ ! -f /etc/containerd/config.toml.orig ] && cp /etc/containerd/config.toml /etc/containerd/config.toml.orig

  # Copy downloaded config over the current one
  cp /tmp/gvisor/config.toml /etc/containerd/config.toml
  NEED_RESTART=1
}


Main() {
  # Check if binary present, install otherwise
  if [[ ! -f  /usr/local/bin/runsc || ! -f /usr/local/bin/containerd-shim-runsc-v1 ]]; then
    Install
  fi

  # Check if containerd config is the one provided, configure otherwise
  diff /tmp/gvisor/config.toml /etc/containerd/config.toml 1>/dev/null 2>&1 || Config

  # If any action has been done needing a containerd restart, do it.
  if [ "$NEED_RESTART" -eq "1" ]; then
    echo "Restarting containerd to finish setup"
    systemctl restart containerd
  fi
}

Main
