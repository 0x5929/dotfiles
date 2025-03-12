# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import json
import time
import subprocess

# from qtile_extras.widget import StatusNotifier
import colors
import owm
from pathlib import Path
# from layouts.wide_center_stacks import WideCenterStack
from libqtile import bar, extension, hook, layout, qtile
from libqtile import widget as widget
from libqtile.config import (
    Click,
    Drag,
    DropDown,
    Group,
    Key,
    KeyChord,
    Match,
    ScratchPad,
    Screen,
)
from libqtile.lazy import lazy

# Make sure 'qtile-extras' is installed or this config will not work.
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration

mod = "mod4"  # Sets mod key to SUPER/WINDOWS
alt = "mod1"  # Sets mod key to SUPER/WINDOWS
myTerm = "alacritty"  # My terminal of choice
myBrowser = "firefox"  # My browser of choice
volumeMixer = "pavucontrol"  # volume mixer
textEditor = "featherpad"
calculator = "gnome-calculator"
home = str(Path.home())


# Allows you to input a name when adding treetab section.
# @lazy.layout.function
# def add_treetab_section(layout):
#     prompt = qtile.widgets_map["prompt"]
#     prompt.start_input("Section name: ", layout.cmd_add_section)


# A function for hide/show all the windows in a group
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()


def go_to_group(name):
    def _inner(qtile):
        if len(qtile.screens) == 1:
            qtile.groups_map[name].toscreen()
            return

        if name in screen_one_groups:
            # focus screen and go to workgroup
            qtile.focus_screen(0)
            qtile.groups_map[name].toscreen()

            # grab name of matching group to second screen
            qtile.focus_screen(1)
            target_group = next(
                group for group in group_configs if group["name"] == name
            )
            qtile.groups_map[target_group["match_group"]].toscreen()

            # focus back on original screen
            qtile.focus_screen(0)
        elif name in screen_two_groups:
            # focus screen and go to workgroup
            qtile.focus_screen(1)
            qtile.groups_map[name].toscreen()

            # grab name of matching group to second screen
            qtile.focus_screen(0)
            target_group = next(
                group for group in group_configs if group["name"] == name
            )
            qtile.groups_map[target_group["match_group"]].toscreen()

            # focus back on original screen
            qtile.focus_screen(1)

    return _inner


def go_to_group_and_move_window(name):
    def _inner(qtile):
        if len(qtile.screens) == 1:
            qtile.current_window.togroup(name, switch_group=False)
            return

        if name in screen_one_groups:
            qtile.current_window.togroup(name, switch_group=False)
            qtile.focus_screen(0)
            qtile.groups_map[name].toscreen()

            qtile.focus_screen(1)
            target_group = next(
                group for group in group_configs if group["name"] == name
            )
            qtile.groups_map[target_group["match_group"]].toscreen()

            qtile.focus_screen(0)
        elif name in screen_two_groups:
            qtile.current_window.togroup(name, switch_group=False)
            qtile.focus_screen(1)
            qtile.groups_map[name].toscreen()

            qtile.focus_screen(0)
            target_group = next(
                group for group in group_configs if group["name"] == name
            )
            qtile.groups_map[target_group["match_group"]].toscreen()

            qtile.focus_screen(1)

    return _inner


def go_to_last_group(qtile):
    screen = qtile.screens.index(qtile.current_screen)

    if screen == 0:
        qtile.focus_screen(1)
        qtile.current_screen.set_group(qtile.current_screen.previous_group)
        qtile.focus_screen(0)
    elif screen == 1:
        qtile.focus_screen(0)
        qtile.current_screen.set_group(qtile.current_screen.previous_group)
        qtile.focus_screen(1)


# A list of available commands that can be bound to keys can be found
# at https://docs.qtile.org/en/latest/manual/config/lazy.html
keys = [
    # The essentials
    Key([mod], "Return", lazy.spawn(myTerm), desc="Terminal"),
    Key(
        [mod, "shift"],
        "Return",
        # lazy.spawn("dmenu_run -bw 3 -c -l 20 -h 24"),
        lazy.spawn("rofi -show drun -show-icons"),
        desc="Run Launcher",
    ),
    Key(
        [alt],
        "tab",
        # lazy.spawn("dmenu_run -bw 3 -c -l 20 -h 24"),
        lazy.spawn("rofi -show window"),
        desc="Run Launcher",
    ),
    
    Key([mod, "shift"], "w", lazy.spawn(home + "/.config/qtile/scripts/wallpaper.sh select"), desc="Update Theme and Wallpaper"),
    Key([mod, "control", "shift"], "w", lazy.spawn(home + "/.config/qtile/scripts/wallpaper.sh"), desc="Update Theme and Wallpaper"),
    Key([mod, "shift"], "u", lazy.spawn("dm-hub -r"), desc="launch dm-hub"),
    Key([mod, "shift"], "s", lazy.spawn(home + "/.config/qtile/scripts/search-hub/hub.sh"), desc="launch rofi-hub"),
    # Key([mod, "shift"], "m", lazy.spawn(home + "/.config/qtile/scripts/search-hub/manpages.sh"), desc="launch rofi-man"),
    # Key([mod, "shift"], "a", lazy.spawn(home + "/.config/qtile/scripts/search-hub/archwiki.sh"), desc="launch rofi-wiki"),
    # Key([mod, "shift"], "y", lazy.spawn(home + "/.config/qtile/scripts/search-hub/youtube.sh"), desc="launch rofi-youtube"),
    # Key([mod, "shift"], "g", lazy.spawn(home + "/.config/qtile/scripts/search-hub/google.sh"), desc="launch rofi-google"),
    # Key([mod, "shift"], "p", lazy.spawn(home + "/.config/qtile/scripts/search-hub/archpackages.sh"), desc="launch rofi-packages"),
    # Key([mod, "shift", "control"], "g", lazy.spawn(home + "/.config/qtile/scripts/search-hub/github.sh"), desc="launch rofi-github"),
    Key([mod, "shift"], "d", lazy.spawn("/home/kevin/.config/eww/dashboard/launch_dashboard"), desc="launch eww-dashboard"),
    Key([mod], "b", lazy.spawn(myBrowser), desc="Web browser"),
    Key([mod], "e", lazy.spawn(myTerm + " -e ranger"), desc="File explorer"),
    Key(
        [mod, "shift", "control"],
        "s",
        lazy.spawn(myTerm + " -e htop"),
        desc="System Info",
    ),
    Key([mod], "s", lazy.function(go_to_last_group)),
    Key(
        [mod, "control"], "m", lazy.spawn(myTerm + " -e cmatrix -C cyan"), desc="Matrix"
    ),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "Tab", lazy.prev_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Switch between windows
    # Some layouts like 'monadtall' only need to use j/k to move
    # through the stack, but other layouts like 'columns' will
    # require all four directions h/j/k/l to move around.
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "g", lazy.layout.client_to_next(), desc="Move window to next stack"),
    Key([mod, "control"], "n", lazy.group.next_window(), desc="next window"),
    Key([mod, "shift"], "n", lazy.group.next_window(), desc="next window"),
    Key([mod, "shift"], "p", lazy.group.prev_window(), desc="prev window"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"],
        "h",
        lazy.layout.shuffle_left(),
        # lazy.layout.move_left().when(layout=["treetab"]),
        # desc="Move window to the left/move tab left in treetab"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        # lazy.layout.move_right().when(layout=["treetab"]),
        # desc="Move window to the right/move tab right in treetab"
    ),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        # lazy.layout.section_down().when(layout=["treetab"]),
        # desc="Move window down/move down a section in treetab"
    ),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_up(),
        # lazy.layout.section_up().when(layout=["treetab"]),
        # desc="Move window downup/move up a section in treetab"
    ),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "space",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # # Treetab prompt
    # Key([mod, "shift"], "a", add_treetab_section, desc='Prompt to add new section in treetab'),
    # Grow/shrink windows left/right.
    # This is mainly for the 'monadtall' and 'monadwide' layouts
    # although it does also work in the 'bsp' and 'columns' layouts.
    Key(
        [mod],
        "equal",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    Key(
        [mod],
        "minus",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    # Grow windows up, down, left, right.  Only works in certain layouts.
    # Works in 'bsp' and 'columns' layout.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Key([mod], "m", lazy.layout.maximize(), desc="Toggle between min and max sizes"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="toggle fullscreen"),
    Key(
        [mod],
        "m",
        minimize_all(),
        desc="Toggle hide/show all windows on current group",
    ),
    # Switch focus of monitors
    Key([mod], "period", lazy.next_screen(), desc="Move focus to next monitor"),
    Key([mod], "comma", lazy.prev_screen(), desc="Move focus to prev monitor"),
    # Scratchpads
    Key(
        [mod],
        "d",
        lazy.group["scratchpad"].dropdown_toggle("term"),
        desc="dropdown scratchpad",
    ),
    Key(
        [mod],
        "p",
        lazy.group["scratchpad"].dropdown_toggle("pad"),
        desc="dropdown scratchpad text editor",
    ),
    Key(
        [mod],
        "c",
        lazy.group["scratchpad"].dropdown_toggle("calc"),
        desc="dropdown scratchpad calculator",
    ),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl -q s +20%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl -q s 20%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl -- set-sink-volume @DEFAULT_SINK@ +10%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl -- set-sink-volume @DEFAULT_SINK@ -20%")),
    Key([], "XF86AudioMute", lazy.spawn("pactl -- set-sink-mute @DEFAULT_SINK@ toggle")),
    Key([], "XF86AudioPlay", lazy.spawn("mpc -q toggle")),
    Key([], "XF86AudioPrev", lazy.spawn("mpc -q prev")),
    Key([], "XF86AudioNext", lazy.spawn("mpc -q next")),
]


# --------------------------------------------------------
# Pywal Colors
# --------------------------------------------------------

pywal_colors = os.path.expanduser('~/.cache/wal/colors.json')
colordict = json.load(open(pywal_colors))
Color0=(colordict['colors']['color0'])
Color1=(colordict['colors']['color1'])
Color2=(colordict['colors']['color2'])
Color3=(colordict['colors']['color3'])
Color4=(colordict['colors']['color4'])
Color5=(colordict['colors']['color5'])
Color6=(colordict['colors']['color6'])
Color7=(colordict['colors']['color7'])
Color8=(colordict['colors']['color8'])
Color9=(colordict['colors']['color9'])
Color10=(colordict['colors']['color10'])
Color11=(colordict['colors']['color11'])
Color12=(colordict['colors']['color12'])
Color13=(colordict['colors']['color13'])
Color14=(colordict['colors']['color14'])
Color15=(colordict['colors']['color15'])

groups = []
group_configs = [
    {"name": "1", "match_group": "2", "label": "1:1", "layout": "max", "screen": 0},
    {
        "name": "2",
        "match_group": "1",
        "label": "2:2",
        "layout": "max",
        "screen": 1,
    },
    {"name": "3", "match_group": "4", "label": "1:3", "layout": "max", "screen": 0},
    {
        "name": "4",
        "match_group": "3",
        "label": "2:4",
        "layout": "max",
        "screen": 1,
    },
    {"name": "5", "match_group": "6", "label": "1:5", "layout": "max", "screen": 0},
    {
        "name": "6",
        "match_group": "5",
        "label": "2:6",
        "layout": "max",
        "screen": 1,
    },
    {"name": "7", "match_group": "8", "label": "1:7", "layout": "max", "screen": 0},
    {
        "name": "8",
        "match_group": "7",
        "label": "2:8",
        "layout": "max",
        "screen": 1,
    },
    {"name": "9", "match_group": "0", "label": "1:9", "layout": "max", "screen": 0},
    {
        "name": "0",
        "match_group": "9",
        "label": "2:0",
        "layout": "max",
        "screen": 1,
    },
]

screen_one_groups = [group["name"] for group in group_configs if group["screen"] == 0]
screen_two_groups = [group["name"] for group in group_configs if group["screen"] == 1]

for i, group in enumerate(group_configs):
    groups.append(
        Group(
            name=group["name"],
            layout=group["layout"].lower(),
            label=group["label"],
            screen_affinity=group["screen"],
        )
    )


for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                # lazy.group[i.name].toscreen(),
                # custom function for binding workspace to screens while moving workspaces
                lazy.function(go_to_group(i.name)),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                # lazy.window.togroup(i.name, switch_group=False),
                # custom function for binding workspace to screens while moving windows
                lazy.function(go_to_group_and_move_window(i.name)),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )
groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown("pad", textEditor, x = 0, y= 0.1, height=0.9, width=0.3),
            DropDown("calc", calculator, x = 0.8, y= 0.2, height=0.4, width=0.2),
            # define a drop down terminal
            DropDown("term", myTerm, x=0, y= 0.5, height=0.5, width=1),
        ],
    ),
)


### COLORSCHEME ###
# Colors are defined in a separate 'colors.py' file.
# There 10 colorschemes available to choose from:
#
# colors = colors.DoomOne
# colors = colors.Dracula
# colors = colors.GruvboxDark
# colors = colors.MonokaiPro
# colors = colors.Nord
# colors = colors.OceanicNext
# colors = colors.Palenight
# colors = colors.SolarizedDark
# colors = colors.SolarizedLight
# colors = colors.TomorrowNight
#
# It is best not manually change the colorscheme; instead run 'dtos-colorscheme'
# which is set to 'MOD + p c'

colors = colors.Dracula

### LAYOUTS ###
# Some settings that I use on almost every layout, which saves us
# from having to type these out for each individual layout.
layout_theme = {
    "border_width": 2,
    "margin": [60, 20, 20, 20],
    "border_focus": Color2,
    "border_normal": colors[0],
}

layouts = [
    # layout.Bsp(**layout_theme),
    # WideCenterStack(**layout_theme),
    layout.Max(
        **layout_theme
        # border_width=0,
        # margin=[60, 0, 0, 0],
    ),
    layout.Stack(**layout_theme, num_stacks=2),
    # layout.Zoomy(**layout_theme, property_big="1.0", columnwidth=850),
    # layout.VerticalTile(**layout_theme),
    # layout.Matrix(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.MonadTall(**layout_theme),
    # layout.MonadWide(**layout_theme),
    # layout.Columns(**layout_theme),
    # layout.TreeTab(
    #      font = "Ubuntu Bold",
    #      fontsize = 11,
    #      border_width = 0,
    #      bg_color = colors[0],
    #      active_bg = colors[8],
    #      active_fg = colors[2],
    #      inactive_bg = colors[1],
    #      inactive_fg = colors[0],
    #      padding_left = 8,
    #      padding_x = 8,
    #      padding_y = 6,
    #      sections = ["ONE", "TWO", "THREE"],
    #      section_fontsize = 10,
    #      section_fg = colors[7],
    #      section_top = 15,
    #      section_bottom = 15,
    #      level_shift = 8,
    #      vspace = 3,
    #      panel_width = 240
    #      ),
    # layout.Floating(**layout_theme),
    layout.Spiral(**layout_theme)
]

# Some settings that I use on almost every widget, which saves us
# from having to type these out for each individual widget.
widget_defaults = dict(font="Ubuntu Bold", fontsize=12, padding=0, background=colors[0])

extension_defaults = widget_defaults.copy()


def init_widgets_list():
    widgets_list = [
        widget.Image(
            filename="~/.config/qtile/icons/python.png",
            scale="False",
            mouse_callbacks={
                "Button1": lambda: qtile.cmd_spawn(myTerm + ' -e "ranger"')
            },
        ),
        widget.Prompt(font="Ubuntu Mono", fontsize=14, foreground=colors[1]),
        widget.GroupBox(
            fontsize=11,
            margin_y=3,
            margin_x=4,
            padding_y=2,
            padding_x=3,
            borderwidth=3,
            active=colors[8],
            inactive=colors[1],
            rounded=False,
            highlight_color=colors[2],
            highlight_method="line",
            this_current_screen_border=colors[7],
            this_screen_border=colors[4],
            other_current_screen_border=colors[7],
            other_screen_border=colors[4],
            visible_groups=["1", "3", "5", "7", "9"],
        ),
        widget.TextBox(
            text="|", font="Ubuntu Mono", foreground=colors[1], padding=2, fontsize=14
        ),
        widget.CurrentLayoutIcon(
            # custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
            foreground=colors[1],
            padding=0,
            scale=0.7,
        ),
        widget.CurrentLayout(foreground=colors[1], padding=5),
        widget.TextBox(
            text="|", font="Ubuntu Mono", foreground=colors[1], padding=2, fontsize=14
        ),
        widget.WindowName(foreground=colors[6], max_chars=40),
        widget.GenPollText(
            update_interval=43200,
            func=lambda: subprocess.check_output(
                "printf $(checkupdates | wc -l)",
                shell=True,
                text=True,
            ),
            foreground=colors[1],
            fmt="⋈  Updates: {} packages",
            decorations=[
                BorderDecoration(
                    colour=colors[1],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.OpenWeather(
            app_key="286235132d0ab66322128a8ba93cd6bc",
            coordinates={"longitude": "-118.0729", "latitude": "34.0806"},
            metric=False,
            foreground=colors[6],
            fmt="❄  Weather: {}",
            decorations=[
                BorderDecoration(
                    colour=colors[6],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.GenPollText(
            update_interval=300,
            func=lambda: subprocess.check_output(
                'printf "%s | IP: %s" "$(uname -r)" "$(ip -4 addr show eno1 | grep -oP \'(?<=inet\s)\d+(\.\d+){3}\')"',
                shell=True,
                text=True,
            ),
            foreground=colors[3],
            fmt="❤  Kernel: {}",
            decorations=[
                BorderDecoration(
                    colour=colors[3],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.GenPollCommand(
            update_interval=300,
            cmd="uptime -p | cut -d 'p' -f2 ",
            shell=True,
            foreground=colors[7],
            fmt="↥  Uptime: {}",
            decorations=[
                BorderDecoration(
                    colour=colors[7],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.CPU(
            format="🖥 Cpu: {load_percent}%",
            foreground=colors[4],
            decorations=[
                BorderDecoration(
                    colour=colors[4],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.NvidiaSensors(
            format=" | Gpu: {temp}°C",
            foreground=colors[4],
            decorations=[
                BorderDecoration(
                    colour=colors[4],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.Memory(
            foreground=colors[8],
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(myTerm + " -e htop")},
            format="{MemPercent: .0f}%",
            fmt="▓ Mem: {} used",
            decorations=[
                BorderDecoration(
                    colour=colors[8],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.DF(
            update_interval=60,
            foreground=colors[5],
            # mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e df')},
            partition="/",
            # format = '[{p}] {uf}{m} ({r:.0f}%)',
            format="/: {uf}{m} free",
            fmt="🖴  Disks: {}",
            visible_on_warn=False,
            decorations=[
                BorderDecoration(
                    colour=colors[5],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        # widget.DF(
        #     update_interval=60,
        #     foreground=colors[5],
        #     # mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e df')},
        #     partition="/home",
        #     # format = '[{p}] {uf}{m} ({r:.0f}%)',
        #     format="/home: {uf}{m} free",
        #     fmt=" | {}",
        #     visible_on_warn=False,
        #     decorations=[
        #         BorderDecoration(
        #             colour=colors[5],
        #             border_width=[0, 0, 2, 0],
        #         )
        #     ],
        # ),
        # widget.Spacer(length=8),
        widget.Volume(
            mouse_callbacks={"Button1": lazy.spawn(volumeMixer)},
            foreground=colors[7],
            fmt="🕫  Vol: {}",
            decorations=[
                BorderDecoration(
                    colour=colors[7],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        # widget.Clock(
        #     foreground="#ffb86c",
        #     format="⏱  HK: %a, %b %d - %H:%M",
        #     timezone="Asia/Hong_Kong",
        #     decorations=[
        #         BorderDecoration(
        #             colour=colors[6],
        #             border_width=[0, 0, 2, 0],
        #         )
        #     ],
        # ),
        # widget.Clock(
        #     foreground=colors[6],
        #     format=" | Moscow: %a, %b %d - %H:%M | ",
        #     timezone="Europe/Moscow",
        #     decorations=[
        #         BorderDecoration(
        #             colour=colors[6],
        #             border_width=[0, 0, 2, 0],
        #         )
        #     ],
        # ),
        # widget.Clock(
        #     foreground=colors[6],
        #     format="Berlin: %a, %b %d - %H:%M | ",
        #     timezone="Europe/Berlin",
        #     decorations=[
        #         BorderDecoration(
        #             colour=colors[6],
        #             border_width=[0, 0, 2, 0],
        #         )
        #     ],
        # ),
        widget.Clock(
            foreground="#ffb86c",
            format="LA: %a, %b %d - %H:%M ⏱",
            decorations=[
                BorderDecoration(
                    colour=colors[6],
                    border_width=[0, 0, 2, 0],
                )
            ],
        ),
        widget.Spacer(length=8),
        widget.Systray(padding=3),
        widget.Spacer(length=8),
    ]
    return widgets_list


# Monitor 1 will display ALL widgets in widgets_list. It is important that this
# is the only monitor that displays all widgets because the systray widget will
# crash if you try to run multiple instances of it.


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1


# All other monitors' bars will display only workspace info
def init_widgets_screen2():
    exclude_indices = [
        2,
        8,
        9,
        10,
        11,
        12,
        13,
        # 14, # uptime
        # 15, # spacer
        16,
        17,
        18,
        # 19,#memory
        20,
        21,
        22,
        23,
        24,
        # 25, # spacer
        26,
        27,
        28,
        # 29, # LA time
        # 30, # spacer
        31,
    ]

    filtered_widget_screen2 = [
        i for j, i in enumerate(init_widgets_list()) if j not in exclude_indices
    ]
    groupbox_screen2 = widget.GroupBox(
        fontsize=11,
        margin_y=3,
        margin_x=4,
        padding_y=2,
        padding_x=3,
        borderwidth=3,
        active=colors[8],
        inactive=colors[1],
        rounded=False,
        highlight_color=colors[2],
        highlight_method="line",
        this_current_screen_border=colors[7],
        this_screen_border=colors[4],
        other_current_screen_border=colors[7],
        other_screen_border=colors[4],
        visible_groups=["2", "4", "6", "8", "0"],
    )
    filtered_widget_screen2[1] = groupbox_screen2
    return filtered_widget_screen2


# For adding transparency to your bar, add (background="#00000000") to the "Screen" line(s)
# For ex: Screen(top=bar.Bar(widgets=init_widgets_screen2(), background="#00000000", size=24)),


def init_screens():
    return [
        # Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26)),
        # Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=26)),
    ]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=colors[8],
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="dialog"),  # dialog boxes
        Match(wm_class="download"),  # downloads
        Match(wm_class="error"),  # error msgs
        Match(wm_class="file_progress"),  # file progress boxes
        Match(wm_class="notification"),  # notifications
        Match(wm_class="pinentry-gtk-2"),  # GPG key password entry
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="gnome-calculator"),  # ssh-askpass
        Match(wm_class="toolbar"),  # toolbars
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="pavucontrol-qt"),  # GPG key password entry
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


@hook.subscribe.startup_once
def autostart():
    autostartscript = "~/.config/qtile/scripts/autostart.sh"
    home = os.path.expanduser(autostartscript)
    subprocess.Popen([
        home
    ])
# @hook.subscribe.changegroup
# def change_group():
#     update_workspace = "~/.config/eww/bar/scripts/workspace"
#     exe = os.path.expanduser(update_workspace)
#     subprocess.Popen([
#         exe
#     ])
#

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
auto_fullscreen = False
