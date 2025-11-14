"""
Installation dependencies
1. rofi (run launcher)
2. pywal (colors)
3. mpc (music player)
4. mpd (music server)
5. brightnessctl (brightness)
6. pavucontrol (audio)
7. eww (dashboard & top bar)
8. alacritty (terminal)
9. featherpad (textpad)
10. firefox (browser)
11. gnome-calculator (calculator)

"""
#################
##   IMPORTS   ##
#################

import os
import json
import time
import colors
import subprocess
from pathlib import Path
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


#####################
##   GLOBAL VARS   ##
#####################

# binds
mod = "mod4"
alt = "mod1"
myTerm = "alacritty"
myBrowser = "firefox" 
volumeMixer = "pavucontrol"
textEditor = "featherpad"
calculator = "gnome-calculator"
home = str(Path.home())

# colors
bg_color = ["#282a36", "#282a36"]
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


# system
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing focus
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

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


########################################
##     GROUPS/WORKSPACE DEFINITION    ##
########################################

group_configs = [
    {
        "name": "1",
        "match_group": "2",
        "label": "1:1",
        "layout": "stack",
        "screen": 0
    },
    {
        "name": "2",
        "match_group": "1",
        "label": "2:2",
        "layout": "stack",
        "screen": 0,
    },
    {
        "name": "3",
        "match_group": "4",
        "label": "1:3",
        "layout": "stack",
        "screen": 0
    },
    {
        "name": "4",
        "match_group": "3",
        "label": "2:4",
        "layout": "stack",
        "screen": 0,
    },
    {
        "name": "5",
        "match_group": "6",
        "label": "1:5",
        "layout": "stack",
        "screen": 0
    },
    {
        "name": "6",
        "match_group": "5",
        "label": "2:6",
        "layout": "stack",
        "screen": 0,
    },
    {
        "name": "7",
        "match_group": "8",
        "label": "1:7",
        "layout": "stack",
        "screen": 0
    },
    {
        "name": "8",
        "match_group": "7",
        "label": "2:8",
        "layout": "stack",
        "screen": 0,
    },
    {
        "name": "9",
        "match_group": "0",
        "label": "1:9",
        "layout": "stack",
        "screen": 0
    },
    {
        "name": "0",
        "match_group": "9",
        "label": "2:0",
        "layout": "stack",
        "screen": 0,
    },
]

groups = []

for i, group in enumerate(group_configs):
    groups.append(
        Group(
            name=group["name"],
            layout=group["layout"].lower(),
            label=group["label"],
            screen_affinity=group["screen"],
        )
    )


###########################
##    UTILITY FUNCTIONS  ##
###########################

@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()


def go_to_group(name):
    def _inner(qtile):
        qtile.groups_map[name].toscreen()
        return
    return _inner


def go_to_group_and_move_window(name):
    def _inner(qtile):
        qtile.current_window.togroup(name, switch_group=False)
        return
    return _inner


def go_to_last_group(qtile):
    screen = qtile.screens.index(qtile.current_screen)
    qtile.current_screen.set_group(qtile.current_screen.previous_group)


######################
##   CMD SHORTCUTS  ##
######################

keys = [
    # program bindings

    Key(
        [mod],
        "Return",
        lazy.spawn(myTerm),
        desc="Terminal"
    ),
    Key(
        [mod, "shift"],
        "Return",
        lazy.spawn("rofi -show drun -show-icons"),
        desc="Run Launcher",
    ),
    Key(
        [alt],
        "tab",
        lazy.spawn("rofi -show window"),
        desc="Run Launcher",
    ),
    Key(
        [mod, "shift"],
        "w",
        lazy.spawn(home + "/.config/qtile/scripts/wallpaper.sh select"),
        desc="Update Theme and Wallpaper",
    ),
    Key(
        [mod, "control", "shift"],
        "w",
        lazy.spawn(home + "/.config/qtile/scripts/wallpaper.sh"),
        desc="Update Theme and Wallpaper",
    ),
    Key(
        [mod, "shift"],
        "s",
        lazy.spawn(home + "/.config/qtile/scripts/search-hub/hub.sh"),
        desc="launch rofi-hub",
    ),
    Key(
        [mod, "shift"],
        "d",
        lazy.spawn("/home/kevin/.config/eww/dashboard/launch_dashboard"),
        desc="launch eww-dashboard",
    ),
    Key(
        [mod],
        "b",
        lazy.spawn(myBrowser),
        desc="Web browser",
    ),
    Key(
        [mod],
        "e",
        lazy.spawn(myTerm + " -e ranger"), desc="File explorer"
    ),
    Key(
        [mod, "shift", "control"],
        "s",
        lazy.spawn(myTerm + " -e htop"),
        desc="System Info",
    ),
    Key(
        [mod, "control"],
        "m",
        lazy.spawn(myTerm + " -e cmatrix -C cyan"),
        desc="Matrix",
    ),
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

    # widnow management
    Key(
        [mod, "control"], "b",
        lazy.spawn('sh -c "/usr/sbin/eww daemon >/dev/null 2>&1 || true; /usr/sbin/eww -c /home/kevin/.config/eww/bar open --toggle bar"'),
        desc="Toggle Eww bar on primary monitor",
    ),
    Key(
        [mod],
        "s",
        lazy.function(go_to_last_group),
        desc="Go to previous workspace group",
    ),
    Key(
        [mod],
        "Tab",
        lazy.next_layout(),
        desc="Toggle between layouts",
    ),
    Key(
        [mod, "shift"],
        "Tab",
        lazy.prev_layout(),
        desc="Toggle between layouts",
    ),
    Key(
        [mod],
        "w",
        lazy.window.kill(),
        desc="Kill focused window",
    ),
    Key(
        [mod, "shift"],
        "r",
        lazy.reload_config(),
        desc="Reload the config",
    ),
    Key(
        [mod, "shift"],
        "q",
        lazy.shutdown(),
        desc="Shutdown Qtile",
    ),
    Key(
        [mod],
        "j",
        lazy.layout.down(),
        desc="Move focus down",
    ),
    Key(
        [mod],
        "k",
        lazy.layout.up(),
        desc="Move focus up",
    ),
    Key(
        [mod],
        "g",
        lazy.layout.client_to_next(),
        desc="Move window to next stack",
    ),
    Key(
        [mod, "shift"],
        "n",
        lazy.group.next_window(),
        desc="next window"
    ),
    Key(
        [mod, "shift"],
        "p",
        lazy.group.prev_window(),
        desc="prev window",
    ),
    Key(
        [mod],
        "space",
        lazy.layout.next(),
        desc="Move window focus to other window",
    ),

    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="toggle floating"
    ),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="toggle fullscreen"
    ),
    Key(
        [mod],
        "m",
        minimize_all(),
        desc="Toggle hide/show all windows on current group",
    ),
    Key(
        [mod],
        "period",
        lazy.next_screen(),
        desc="Move focus to next monitor",
    ),
    Key(
        [mod],
        "comma",
        lazy.prev_screen(),
        desc="Move focus to prev monitor",
    ),

    # system bindings
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("brightnessctl -q s +20%"),
        desc="brightnessctl higher brightness",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("brightnessctl -q s 20%-"),
        desc="brightnessctl lower brightness",
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl -- set-sink-volume @DEFAULT_SINK@ +10%"),
        desc="Audio higher vol",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl -- set-sink-volume @DEFAULT_SINK@ -20%"),
        desc="Audio lower vol",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("pactl -- set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="Audio mute",
    ),
    Key(
        [],
        "XF86AudioPlay",
        lazy.spawn("mpc -q toggle"),
        desc="Audio play/pause",
    ),
    Key(
        [],
        "XF86AudioPrev",
        lazy.spawn("mpc -q prev"),
        desc="Audio prev",
    ),
    Key(
        [],
        "XF86AudioNext",
        lazy.spawn("mpc -q next"),
        desc="Audio next",
    ),
]

# group/workspace keybindings
for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.function(go_to_group(i.name)),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.function(go_to_group_and_move_window(i.name)),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )

################################
##   SCRATCHPAD DEFINITIIONS  ##
################################

groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown("pad", textEditor, x = 0, y= 0.1, height=0.9, width=0.3),
            DropDown("calc", calculator, x = 0.8, y= 0.2, height=0.4, width=0.2),
            DropDown("term", myTerm, x=0, y= 0.5, height=0.5, width=1),
        ],
    ),
)

################
##   LAYOUTS  ##
################

layout_theme = {
    "border_width": 2,
    "margin": [60, 20, 20, 20],
    "border_focus": Color2,
    "border_normal": bg_color,
}

layouts = [
    layout.Max(
        **layout_theme
    ),
    layout.Stack(**layout_theme, num_stacks=2),
    layout.Spiral(**layout_theme)
]


def init_screens():
    return [
        Screen(),
    ]


#########################
##   FLOATING CONFIGS  ##
#########################

floating_layout = layout.Floating(
    border_focus=Color2,
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="dialog"),
        Match(wm_class="download"),
        Match(wm_class="error"),
        Match(wm_class="file_progress"),
        Match(wm_class="notification"),
        Match(wm_class="pinentry-gtk-2"),
        Match(wm_class="ssh-askpass"),
        Match(wm_class="gnome-calculator"),
        Match(wm_class="toolbar"),
        Match(title="pinentry"),
        Match(wm_class="pavucontrol-qt"),
    ],
)

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click(
        [mod],
        "Button2",
        lazy.window.bring_to_front()
    ),
]


######################
##   MOUSE CONFIGS  ##
######################

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False

########################
##   STARTUP SCRIPTS  ##
########################

@hook.subscribe.startup_once
def autostart():
    autostartscript = "~/.config/qtile/scripts/autostart.sh"
    home = os.path.expanduser(autostartscript)
    subprocess.Popen([
        home
    ])

if __name__ in ["config", "__main__"]:
    screens = init_screens()

