# Sway / Wayland trial

This branch (`wayland`) adds a Sway-based Wayland session alongside the
existing i3 setup. Both can be installed simultaneously; pick which one
to launch from the display manager.

## Layout

- `sway/` — Sway compositor config (port of `i3/.config/i3/config`)
- `waybar/` — status bar (replaces i3blocks)
- `swaylock/` — screen locker config
- `swayidle/` — idle/suspend daemon config (used via `-C`, not inline)
- `environment.d/` — Wayland env vars (`MOZ_ENABLE_WAYLAND`, `NIXOS_OZONE_WL`,
  etc.) read by systemd `--user` and inherited by sway children
- `xdg-desktop-portal/` — pins the wlr backend for screen sharing so
  `xdg-desktop-portal-gnome` doesn't win and break capture

## Install

```bash
# 1. Install Wayland stack + stow new configs (one command, idempotent).
~/Dotfiles/dependencies.sh

# 2. Log out, pick "Sway" at the display manager, log back in.
```

## What's different from i3

| i3 thing                       | Sway equivalent             |
|--------------------------------|-----------------------------|
| `i3blocks`                     | `waybar`                    |
| `i3lock` + `xss-lock`          | `swaylock` + `swayidle`     |
| `feh --bg-scale`               | `output * bg ... fill` (crops to fit) |
| `flameshot gui --clipboard`    | `grim -g "$(slurp)" \| wl-copy` (no annotation tools — see below) |
| `xclip` / `xsel`               | `wl-copy` / `wl-paste`      |
| `xrandr`                       | `swaymsg output ...` / `wlr-randr` |
| `synclient` touchpad tweaks    | `input "type:touchpad" {}`  |
| `dex --autostart -e i3`        | `dex --autostart -e sway`   |
| `i3-sensible-terminal`         | `foot` (set as `$term`)     |
| `~/Scripts/public/brightness`  | `brightnessctl set 10%+/-`  |
| `i3lock` keybind               | `loginctl lock-session` (via swayidle `lock` hook) |

## Known caveats

- **Screenshots lose annotation features.** `grim -g "$(slurp)" \| wl-copy`
  selects a region and copies it. flameshot's draw/arrow/blur tools are
  gone. If you used them, pipe through `swappy` instead:
  `grim -g "$(slurp)" - | swappy -f -`.
- **Screen sharing** in Chrome/Discord needs `xdg-desktop-portal-wlr`
  (installed) AND the wlr backend being preferred over the gnome one
  (handled by `xdg-desktop-portal/sway-portals.conf`).
- **Discord screen sharing** is broken under XWayland; either use Vesktop
  (Wayland-native fork) or accept that screen sharing in Discord won't
  work on Wayland.
- **Apps assuming X11** run via XWayland transparently. The env-vars
  package pushes Electron/Firefox/Qt apps to Wayland-native where they
  support it.
- **Czech keyboard layout** is set in the sway config (`xkb_layout cz,us`).
  Toggle with Alt+Shift.

## Reverting

Just log in with the i3 session at the display manager. Nothing here
touches the i3 config. To remove Sway entirely:

```bash
cd ~/Dotfiles && stow -D sway waybar swaylock swayidle environment.d xdg-desktop-portal
sudo apt autoremove --purge sway
```
