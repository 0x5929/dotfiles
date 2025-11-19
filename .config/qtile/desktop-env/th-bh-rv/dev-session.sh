#!/usr/bin/env bash
set -euo pipefail

# --- 1) Start Docker (if not already active) ---
if ! systemctl is-active --quiet docker; then
  systemctl start docker
fi

# --- 2) Start Minikube (if not already running) ---
if ! minikube status >/dev/null 2>&1; then
  minikube start
fi

# --- 3) Finally, attach/create your tmux session in the foreground ---
exec tmuxinator start gtec
