# Sway / Wayland trial

This branch (`wayland`) adds a Sway-based Wayland session alongside the
existing i3 setup. Both can be installed simultaneously; pick which one
to launch from the display manager.

## Layout

- `sway/` — Sway compositor config (port of `i3/.config/i3/config`)
- `waybar/` — status bar (replaces i3blocks)
- `swaylock/` — screen locker config
- `swayidle/` — idle/suspend handling (configured inline in sway config)

## Install

```bash
# 1. Install Wayland stack (already added to dependencies.sh)
~/Dotfiles/dependencies.sh

# 2. Stow the new configs (idempotent; safe to re-run)
cd ~/Dotfiles && stow sway waybar swaylock swayidle

# 3. Log out, pick "Sway" at the display manager, log back in.
```

## What's different from i3

| i3 thing                       | Sway equivalent             |
|--------------------------------|-----------------------------|
| `i3blocks`                     | `waybar`                    |
| `i3lock` + `xss-lock`          | `swaylock` + `swayidle`     |
| `feh --bg-scale`               | `output * bg ... fill`      |
| `flameshot gui --clipboard`    | `grim -g "$(slurp)" \| wl-copy` |
| `xclip` / `xsel`               | `wl-copy` / `wl-paste`      |
| `xrandr`                       | `swaymsg output ...` / `wlr-randr` |
| `synclient` touchpad tweaks    | `input "type:touchpad" {}`  |
| `dex --autostart -e i3`        | `dex --autostart -e sway`   |
| `i3-sensible-terminal`         | `foot` (set as `$term`)     |

## Known caveats (Wayland in general)

- **Screen sharing** in Chrome/Discord needs `xdg-desktop-portal-wlr`
  (installed by `dependencies.sh`). First call prompts you to select a
  window/output.
- **Apps assuming X11** run via XWayland transparently. Anything broken
  there is the app's fault, not Sway's.
- **Czech keyboard layout** is set in the sway config (`xkb_layout cz,us`).
  Toggle with Alt+Shift.

## Reverting

Just log in with the i3 session at the display manager. Nothing here
touches the i3 config. To remove Sway entirely:

```bash
cd ~/Dotfiles && stow -D sway waybar swaylock swayidle
sudo apt remove sway swaylock swayidle swaybg waybar foot grim slurp wl-clipboard
```
