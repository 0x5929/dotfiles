#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="SYS"
PROJECT_NAME="system_display"

# --- 3) Attach if session already exists, otherwise start tmuxinator ---
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  # Session already running: just attach to it
  exec tmux attach-session -t "$SESSION_NAME"
else
  # No existing session: start tmux via tmuxinator project
  exec tmuxinator start "$PROJECT_NAME"
fi

