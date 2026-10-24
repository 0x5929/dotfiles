# Clone

To clone `git clone --recurse-submodules <your-dotfiles-repo-url>`

# After clone

`git submodule update --init --recursive`

# NOTE To commit

The best we can do when copying over certain dirs controlled by other programs
is to add a pre-commit hook that will copy the contents of source to dest dir

**So Remember to** `git status` even after `git add .`

# Niri: DMS + Noctalia sessions

One niri setup with two login sessions that share a base config:

| Login entry       | Shell                   | Niri config loaded            |
| ----------------- | ----------------------- | ----------------------------- |
| `Niri (DMS)`      | DankMaterialShell (DMS) | `~/.config/niri/dms.kdl`      |
| `Niri (Noctalia)` | Noctalia v5             | `~/.config/niri/noctalia.kdl` |

Hyprland, Qtile, etc. are unaffected.

## Layout

```
.config/niri/                    # stowed: stow -vt ~/.config/niri niri
├── config.kdl                   # shared base (input, layout, animations, window rules, startup apps)
├── dms.kdl                      # DMS session: config.kdl + dms/* + custom/*
├── noctalia.kdl                 # Noctalia session: config.kdl + noctalia/* + custom/*
├── dms/                         # managed by DMS (colors, layout, binds, outputs, cursor, ...)
├── noctalia/                    # Noctalia-only: startup, rules, colors, layout, alttab, binds, cursor
├── custom/                      # shared personal binds, scratchpad, live wallpapers (mpvpaper)
└── scripts/

.config/noctalia/                # stowed: stow -vt ~/.config/noctalia noctalia
├── config.toml                  # hand-written Noctalia config (wallpaper dir, user templates)
└── templates/
    ├── niri-colors.kdl.tmpl     # → ~/.config/niri/noctalia-colors.kdl (generated, not in git)
    └── terminal-sequences       # → ~/.config/kitty/themes/noctalia.conf
```

### Include order

**`dms.kdl`** (identical merge order to the original single-file config):

```kdl
include "config.kdl"
include "dms/colors.kdl"
include "dms/layout.kdl"
include "dms/alttab.kdl"
include "dms/binds.kdl"
include "dms/outputs.kdl"
include "dms/cursor.kdl"
include "custom/binds.kdl"
include "custom/scratch.kdl"
include "custom/wallpapers.kdl"
```

**`noctalia.kdl`**:

```kdl
include "config.kdl"
include "noctalia/startup.kdl"
include "noctalia/rules.kdl"
include "noctalia/colors.kdl"
include "noctalia-colors.kdl"     // wallpaper-generated colors (overrides static ones)
include "noctalia/layout.kdl"
include "noctalia/alttab.kdl"
include "noctalia/binds.kdl"
include "dms/outputs.kdl"         // read-only reuse of monitor layout
include "noctalia/cursor.kdl"
include "custom/binds.kdl"
include "custom/scratch.kdl"
// custom/wallpapers.kdl intentionally omitted: live wallpapers are DMS-only
```

## System files (not stowed)

| File                                                                       | Purpose                                                                             |
| -------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| `/usr/local/bin/niri-dms`                                                  | Sets `NIRI_CONFIG=~/.config/niri/dms.kdl`, runs `niri-session`, unsets it on logout |
| `/usr/local/bin/niri-noctalia`                                             | Same, for `noctalia.kdl`                                                            |
| `/usr/share/wayland-sessions/niri-dms.desktop`                             | Login entry "Niri (DMS)"                                                            |
| `/usr/share/wayland-sessions/niri-noctalia.desktop`                        | Login entry "Niri (Noctalia)"                                                       |
| `~/.config/systemd/user/dms.service.d/skip-noctalia.conf`                  | Skips DMS in the Noctalia session                                                   |
| `~/.config/systemd/user/dcal.service.d/skip-noctalia.conf`                 | Skips Dank Calendar in the Noctalia session                                         |
| `/etc/pacman.conf` → `NoExtract = usr/share/wayland-sessions/niri.desktop` | Hides the stock "Niri" entry (it would load the bare base config)                   |

Wrapper script (`niri-noctalia`; `niri-dms` is the same with `dms.kdl`):

```sh
#!/bin/sh
export NIRI_CONFIG="$HOME/.config/niri/noctalia.kdl"
niri-session "$@"
systemctl --user unset-environment NIRI_CONFIG
```

Skip rule (used for both `dms.service` and `dcal.service`):

```ini
[Service]
ExecCondition=/bin/sh -c 'case "$${NIRI_CONFIG:-}" in *noctalia.kdl) exit 1 ;; esac; exit 0'
```

## Noctalia wallpaper theming → niri colors

`~/.config/noctalia/config.toml`:

```toml
[wallpaper]
directory = "/home/kevin/Pictures/wallpaper"

[theme.templates.user.terminal-sequences]
input_path = '~/.config/noctalia/templates/terminal-sequences'
output_path = '~/.config/kitty/themes/noctalia.conf'

[theme.templates.user.niri-colors]
input_path  = '/home/kevin/.config/noctalia/templates/niri-colors.kdl.tmpl'
output_path = '/home/kevin/.config/niri/noctalia-colors.kdl'
```

Template variables use the `{{colors.<name>.default.hex}}` form (e.g. `primary`, `outline`, `error`, `primary_container`).
Niri watches included files, so a wallpaper change re-themes the focus ring automatically.

## Rules / gotchas

- **Never put DMS or Noctalia includes in `config.kdl`.** It is the shared base.
- **DMS:** ignore any "not included" / **Setup** banner. Don't click Setup or run `dms setup`; it would write DMS includes into the shared `config.kdl`.
- **Noctalia:** keep the **built-in niri template OFF**. It writes to `~/.config/niri/noctalia.kdl` and clobbers the session file. Use the user template above instead.
- **Edit stowed files at their dotfiles path** when using `sed -i` (it replaces symlinks with regular files).
- **Fresh install:** `noctalia-colors.kdl` is generated, not tracked. Run `noctalia msg templates-apply` once before logging into the Noctalia session, or it will fail to load.
- **App theming crosses sessions:** Noctalia templates that write into app configs (GTK, Qt, kitty, ...) also change those apps under DMS.
- **Check which config is active** (`echo $NIRI_CONFIG` in a terminal is empty by design):

  ```sh
  systemctl --user show-environment | grep NIRI_CONFIG
  ```

## Recovery

- **Session won't load:** `Ctrl+Alt+F3` → log in →

  ```sh
  niri validate -c ~/.config/niri/dms.kdl
  niri validate -c ~/.config/niri/noctalia.kdl
  ```

- **Kill a broken session from a TTY:** `pkill -x niri`, then `Ctrl+Alt+F1`/`F2` and log in again.
- **Restart Noctalia in place:** `pkill -x noctalia; niri msg action spawn -- noctalia`
- **Re-link after moving files:** `cd ~/Projects/personal/dotfiles/.config && stow -R -vt ~/.config/niri niri`
