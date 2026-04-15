# xdg-desktop-portal-termfilechooser

Replaces the default GTK file picker with [yazi](https://yazi-rs.github.io/) via [xdg-desktop-portal-termfilechooser](https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser). When a browser or any application opens a file dialog, yazi launches in a gnome-terminal window instead.

## Setup

```sh
# 1. Install the package (handled by home-manager flake)
home-manager switch --flake ~/Dotfiles

# 2. Symlink config files
cd ~/Dotfiles && stow xdg-desktop-portal-termfilechooser

# 3. Generate dbus/systemd service files and restart portals
~/Dotfiles/scripts/setup-termfilechooser.sh
```

## Firefox (X11 only)

On X11, Firefox doesn't use the XDG portal by default. Enable it in `about:config`:

```
widget.use-xdg-desktop-portal.file-picker = 1
```

This is not needed on Wayland.

## Usage

When a file picker dialog opens:
- Navigate with yazi as usual
- **Enter** to select the file/directory and pass it back
- **Space** to select multiple files, then **Enter** to confirm

## Files

| File | Purpose |
|------|---------|
| `.config/xdg-desktop-portal-termfilechooser/config` | Main config — sets yazi wrapper and gnome-terminal as TERMCMD |
| `.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh` | Wrapper script that launches yazi with `--chooser-file` |
| `.config/xdg-desktop-portal/i3-portals.conf` | Routes FileChooser to termfilechooser, everything else to GTK |
| `.local/share/xdg-desktop-portal/portals/termfilechooser.portal` | Portal definition |

## Notes

- The dbus and systemd service files are **not** stowed because they contain nix store paths that change on package updates. Run `setup-termfilechooser.sh` again after updating the package.
- The `TERMCMD` uses `gnome-terminal --wait` so the wrapper blocks until yazi exits. Without `--wait`, gnome-terminal forks and the portal reads an empty output file.
