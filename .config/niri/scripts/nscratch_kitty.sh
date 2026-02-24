#!/usr/bin/env bash
set -euo pipefail

APP_ID="dms-dropdown-term"
SCRATCH_WS="scratch"
SPAWN=(kitty --app-id "$APP_ID" --title "Dropdown Terminal")

# Determine current workspace idx (on focused output) WITHOUT later forcing focus-workspace
FOCUSED_OUTPUT="$(niri msg --json focused-output | jq -r '.name')"
CUR_IDX="$(niri msg --json workspaces | jq -r --arg out "$FOCUSED_OUTPUT" '
  .[] | select(.output==$out and (.is_active==true or .is_focused==true)) | .idx
' | head -n1)"

WIN_JSON="$(niri msg --json windows | jq -c --arg app "$APP_ID" '
  .[] | select(.app_id==$app) | {id,is_focused}
' | head -n1 || true)"

if [[ -z "${WIN_JSON:-}" || "${WIN_JSON}" == "null" ]]; then
  niri msg action spawn -- "${SPAWN[@]}"
  exit 0
fi

WIN_ID="$(jq -r '.id' <<<"$WIN_JSON")"
IS_FOCUSED="$(jq -r '.is_focused' <<<"$WIN_JSON")"

if [[ "$IS_FOCUSED" == "true" ]]; then
  # Hide: this stays on current workspace; no workspace hopping
  niri msg action move-window-to-workspace "$SCRATCH_WS"
  niri msg action focus-window-previous || true
  exit 0
fi

# Show: yes, focus-window will hop to where kitty is (scratch), but we won't do any extra focus-workspace hops.
niri msg action focus-window --id "$WIN_ID"
niri msg action move-window-to-workspace "$CUR_IDX"

# If you have multi-monitor and it sometimes lands on the wrong monitor, keep this.
# It doesn't require changing your current workspace.
niri msg action move-window-to-monitor "$FOCUSED_OUTPUT" || true

# Bring focus back to where you were (minimizes visible twitch), then focus kitty (now on your ws)
niri msg action focus-window-previous || true
niri msg action focus-window --id "$WIN_ID"
