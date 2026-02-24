#!/usr/bin/env python3
# Adapted from the many ideas shared at: https://github.com/YaLTeR/niri/discussions/329

import argparse
import json
import os
import subprocess
import sys

scratch_window = {}
focused_workspace = {}
scratch_workspace = os.getenv("NS_WORKSPACE", "scratch")


def niri_cmd(cmd_args, check=True):
    # check=True so failures are not silent
    return subprocess.run(["niri", "msg", "action"] + cmd_args, check=check)


def focus_window(window_id):
    niri_cmd(["focus-window", "--id", str(window_id)])


def move_focused_window_to_workspace(workspace_ref, focus=False):
    # Your niri 25.11: moves the FOCUSED window only; workspace_ref = idx or name
    niri_cmd(["move-window-to-workspace", str(workspace_ref)])
    if not focus:
        # Best-effort: restore previous focus so it feels like "send away"
        niri_cmd(["focus-window-previous"], check=False)


def move_window_to_scratchpad(window_id, animations):
    # OLD (not supported on your build):
    # niri_cmd(
    #     [
    #         "move-window-to-workspace",
    #         "--window-id",
    #         str(window_id),
    #         scratch_workspace,
    #         "--focus=false",
    #     ]
    # )

    # NEW: focus the window, then move focused window to scratch workspace
    focus_window(window_id)
    move_focused_window_to_workspace(scratch_workspace, focus=False)

    if animations:
        niri_cmd(["move-window-to-tiling", "--id", str(window_id)])


def bring_scratchpad_window_to_focus(window_id, args):
    # OLD (not supported on your build):
    # niri_cmd(
    #     [
    #         "move-window-to-workspace",
    #         "--window-id",
    #         str(window_id),
    #         str(focused_workspace["idx"]),
    #     ]
    # )

    # NEW: focus the window, then move focused window to current workspace idx
    focus_window(window_id)
    niri_cmd(["move-window-to-workspace", str(focused_workspace["idx"])])

    if args.multi_monitor:
        niri_cmd(
            [
                "move-window-to-monitor",
                "--id",
                str(window_id),
                str(focused_workspace["output"]),
            ]
        )

    if args.animations and not scratch_window["is_floating"]:
        niri_cmd(["move-window-to-floating", "--id", str(window_id)])

    niri_cmd(["focus-window", "--id", str(window_id)])


def find_scratch_window(args, windows):
    for window in windows:
        if (args.app_id and window.get("app_id") == args.app_id) or (
            args.title and window.get("title") == args.title
        ):
            scratch_window["id"] = window["id"]
            scratch_window["workspace_id"] = window["workspace_id"]
            scratch_window["is_focused"] = window["is_focused"]
            scratch_window["is_floating"] = window["is_floating"]
            break


def fetch_focused_workspace():
    props = subprocess.run(
        ["niri", "msg", "--json", "workspaces"],
        capture_output=True,
        text=True,
        check=True,
    )
    workspaces = json.loads(props.stdout)

    for workspace in workspaces:
        if workspace.get("is_focused") or workspace.get("is_active"):
            focused_workspace["idx"] = workspace["idx"]
            focused_workspace["output"] = workspace.get("output")
            return workspace["id"]


def ns(parser):
    args = parser.parse_args()

    props = subprocess.run(
        ["niri", "msg", "--json", "windows"],
        capture_output=True,
        text=True,
        check=True,
    )
    windows = json.loads(props.stdout)

    find_scratch_window(args, windows)

    if not scratch_window:
        if args.spawn:
            fetch_focused_workspace()

        niri_cmd(["spawn", "--"] + args.spawn.split(" "))

        # Wait for the window to appear, then bring it to the focused workspace
        for _ in range(60):  # ~3s max at 50ms intervals
            props = subprocess.run(
                ["niri", "msg", "--json", "windows"],
                capture_output=True,
                text=True,
            )
            windows = json.loads(props.stdout)
            find_scratch_window(args, windows)
            if scratch_window:
                bring_scratchpad_window_to_focus(scratch_window["id"], args)
                break

            import time

            time.sleep(0.05)

        sys.exit(0)
        # niri_cmd(["spawn", "--"] + args.spawn.split(" "))
        # sys.exit(0)
    else:
        parser.print_help()
        sys.exit(1)

    window_id = scratch_window["id"]

    if not scratch_window["is_focused"]:
        workspace_id = fetch_focused_workspace()
        if scratch_window["workspace_id"] != workspace_id:
            bring_scratchpad_window_to_focus(window_id, args)
            return

    move_window_to_scratchpad(window_id, args.animations)


def main():
    parser = argparse.ArgumentParser(
        prog="nscratch", description="Niri Scratchpad support"
    )
    group = parser.add_mutually_exclusive_group(required=True)

    group.add_argument("-id", "--app-id", help="The application identifier")
    group.add_argument("-t", "--title", help="The application title")
    parser.add_argument(
        "-s", "--spawn", help="The process name to spawn when non-existing"
    )
    parser.add_argument(
        "-a", "--animations", action="store_true", help="Enable animations"
    )
    parser.add_argument(
        "-m", "--multi-monitor", action="store_true", help="Multi-monitor support"
    )

    ns(parser)


if __name__ == "__main__":
    main()
