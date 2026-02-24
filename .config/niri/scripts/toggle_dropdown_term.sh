#!/usr/bin/env bash
set -euo pipefail

APP_ID="dms-dropdown-term"
STATE_FILE="/tmp/niri.${APP_ID}.state"
SLIVER=-100 # px left visible when "hidden" (set 0 to fully hide)

# Find the dropdown terminal window JSON
WIN_JSON="$(niri msg --json windows | jq -c --arg app "$APP_ID" '.[] | select(.app_id==$app)' | head -n 1)"
if [[ -z "${WIN_JSON:-}" || "${WIN_JSON}" == "null" ]]; then
  # Spawn if missing
  kitty --app-id "$APP_ID" --title "Dropdown Terminal" &
  exit 0
fi

WIN_ID="$(jq -r '.id' <<<"$WIN_JSON")"

# Current position + size (these fields exist in your JSON)
X="$(jq -r '.layout.tile_pos_in_workspace_view[0]' <<<"$WIN_JSON")"
Y="$(jq -r '.layout.tile_pos_in_workspace_view[1]' <<<"$WIN_JSON")"
H="$(jq -r '.layout.window_size[1]' <<<"$WIN_JSON")"

# Compute a "hidden" Y by pushing it down by its own height (minus a tiny sliver)
HIDE_Y="$(
  python - <<PY
y=float("$Y"); h=float("$H"); sl=float("$SLIVER")
print(int(y + h - sl))
PY
)"

# Determine current visible/hidden state:
# If we previously stored a "shown Y", use it; else assume current Y is shown Y.
if [[ -f "$STATE_FILE" ]]; then
  SHOWN_Y="$(cat "$STATE_FILE" | tr -d '\n')"
else
  SHOWN_Y="$(
    python - <<PY
print(int(float("$Y")))
PY
  )"
  echo "$SHOWN_Y" >"$STATE_FILE"
fi

# Heuristic: if window is currently at (or below) hide position => show it, else hide it
# (tolerate small drift)
IS_HIDDEN="$(
  python - <<PY
y=float("$Y"); hide=float("$HIDE_Y")
print("1" if y >= hide-2 else "0")
PY
)"

if [[ "$IS_HIDDEN" == "1" ]]; then
  # SHOW: move back to stored pinned position and focus
  niri msg action move-floating-window --id "$WIN_ID" -x "$X" -y "$SHOWN_Y"
  niri msg action focus-window --id "$WIN_ID"
else
  # HIDE: remember current shown Y, then push off-screen
  echo "$(
    python - <<PY
print(int(float("$Y")))
PY
  )" >"$STATE_FILE"
  niri msg action move-floating-window --id "$WIN_ID" -x "$X" -y "$HIDE_Y"
  niri msg action focus-window-previous || true
fi
