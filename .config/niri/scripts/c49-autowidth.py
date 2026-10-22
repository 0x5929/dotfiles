#!/usr/bin/env python3
"""
Auto-size columns on the Samsung C49 (niri).

  1 column   -> 1/2 width (centered by always-center-single-column)
  2 columns  -> 1/2 width each
  3+ columns -> 1/3 width each

- Only acts when the number of columns on a C49 workspace changes.
- Columns you resize by hand (Mod+R, Mod+F, Mod+Minus/Equal, mouse) are
  remembered and never auto-resized again. Close and reopen the window to
  put it back under auto-sizing.
- Pair with `default-column-width { proportion 0.33333; }` on the C49 output
  so new windows open at their final size and the view doesn't leave a gap.
- Other monitors are never touched.
"""

import json
import subprocess
import time

TARGET_MODEL = "C49HG9x"  # matched against the monitor's model name
FEW_WIDTH = "50%"
MANY_WIDTH = "33.333%"
MANY_FROM = 3  # this many columns or more -> MANY_WIDTH
TOLERANCE_PX = 2

RELEVANT_EVENTS = {
    "WindowsChanged",
    "WindowOpenedOrChanged",
    "WindowClosed",
    "WindowLayoutsChanged",
    "WorkspacesChanged",
    "WorkspaceActivated",
}

last_counts = {}  # workspace id -> number of columns last seen
expected = {}  # window id -> tile width (px) right after our last resize
manual = set()  # window ids the user resized by hand


def niri_json(*args):
    out = subprocess.run(
        ["niri", "msg", "--json", *args],
        capture_output=True,
        text=True,
        check=True,
    ).stdout
    return json.loads(out)


def target_connector():
    for name, out in niri_json("outputs").items():
        if TARGET_MODEL in (out.get("model") or ""):
            return name
    return None


def c49_columns(conn):
    """Return (workspace ids, {ws: {col index: [(win id, width), ...]}})."""
    ws_ids = {w["id"] for w in niri_json("workspaces") if w.get("output") == conn}
    columns = {}
    for win in niri_json("windows"):
        if win.get("is_floating") or win.get("workspace_id") not in ws_ids:
            continue
        layout = win.get("layout") or {}
        pos = layout.get("pos_in_scrolling_layout")
        if not pos:
            continue
        size = layout.get("tile_size") or [None]
        columns.setdefault(win["workspace_id"], {}).setdefault(pos[0], []).append(
            (win["id"], size[0])
        )
    return ws_ids, columns


def remember_widths(columns):
    for cols in columns.values():
        for col in cols.values():
            for wid, width in col:
                if wid not in manual and width is not None:
                    expected[wid] = width


def update():
    conn = target_connector()
    if conn is None:
        return

    ws_ids, columns = c49_columns(conn)

    # Spot hand-made resizes: width changed without us doing it.
    alive = set()
    for cols in columns.values():
        for col in cols.values():
            for wid, width in col:
                alive.add(wid)
                exp = expected.get(wid)
                if (
                    exp is not None
                    and width is not None
                    and abs(width - exp) > TOLERANCE_PX
                ):
                    manual.add(wid)
                    expected.pop(wid, None)

    # Forget windows that closed or left the C49.
    manual.intersection_update(alive)
    for wid in list(expected):
        if wid not in alive:
            del expected[wid]

    resized = False
    for ws in ws_ids:
        cols = columns.get(ws, {})
        count = len(cols)
        if last_counts.get(ws) == count:
            continue
        last_counts[ws] = count
        if count == 0:
            continue

        width = MANY_WIDTH if count >= MANY_FROM else FEW_WIDTH
        for col in cols.values():
            if any(wid in manual for wid, _ in col):
                continue
            subprocess.run(
                [
                    "niri",
                    "msg",
                    "action",
                    "set-window-width",
                    "--id",
                    str(col[0][0]),
                    width,
                ],
                capture_output=True,
            )
            resized = True

    if resized:
        time.sleep(0.1)
        _, columns = c49_columns(conn)
    remember_widths(columns)


def main():
    try:
        update()
    except Exception:
        pass

    proc = subprocess.Popen(
        ["niri", "msg", "--json", "event-stream"],
        stdout=subprocess.PIPE,
        text=True,
    )
    for line in proc.stdout:
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue
        if next(iter(event), None) in RELEVANT_EVENTS:
            try:
                update()
            except Exception:
                pass


if __name__ == "__main__":
    main()
