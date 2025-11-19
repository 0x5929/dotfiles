#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="GT"
PROJECT_NAME="gtec"

# --- 1) Start Docker (if not already active) ---
if ! systemctl is-active --quiet docker; then
  systemctl start docker
fi

# --- 2) Start Minikube (if not already running) ---
if ! minikube status >/dev/null 2>&1; then
  minikube start
fi

# --- 3) Attach if session already exists, otherwise start tmuxinator ---
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  # Session already running: just attach to it
  exec tmux attach-session -t "$SESSION_NAME"
else
  # No existing session: start tmux via tmuxinator project
  exec tmuxinator start "$PROJECT_NAME"
fi
