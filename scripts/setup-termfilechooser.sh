#!/bin/sh
# Sets up xdg-desktop-portal-termfilechooser dbus and systemd service files.
# These reference the nix store path which changes on updates, so they can't be stowed.
# Run this after `home-manager switch` or `nix-env -i xdg-desktop-portal-termfilechooser`.

set -e

bin=$(readlink -f "$HOME/.nix-profile/bin/xdg-desktop-portal-termfilechooser" 2>/dev/null) || true

if [ -z "$bin" ]; then
    # fallback: find it via the libexec path relative to the share dir
    pkg=$(readlink -f "$HOME/.nix-profile/share/xdg-desktop-portal-termfilechooser" 2>/dev/null) || true
    if [ -n "$pkg" ]; then
        store_path=$(echo "$pkg" | sed 's|/share/.*||')
        bin="$store_path/libexec/xdg-desktop-portal-termfilechooser"
    fi
fi

if [ -z "$bin" ] || [ ! -x "$bin" ]; then
    echo "Error: xdg-desktop-portal-termfilechooser not found in nix profile" >&2
    exit 1
fi

echo "Using binary: $bin"

mkdir -p "$HOME/.local/share/dbus-1/services"
cat > "$HOME/.local/share/dbus-1/services/org.freedesktop.impl.portal.desktop.termfilechooser.service" <<EOF
[D-BUS Service]
Name=org.freedesktop.impl.portal.desktop.termfilechooser
Exec=$bin
SystemdService=xdg-desktop-portal-termfilechooser.service
EOF

mkdir -p "$HOME/.config/systemd/user"
cat > "$HOME/.config/systemd/user/xdg-desktop-portal-termfilechooser.service" <<EOF
[Unit]
Description=Portal service (terminal file chooser implementation)
PartOf=graphical-session.target
After=graphical-session.target

[Service]
Type=dbus
BusName=org.freedesktop.impl.portal.desktop.termfilechooser
ExecStart=$bin
Restart=on-failure
Slice=session.slice
EOF

systemctl --user daemon-reload
systemctl --user restart xdg-desktop-portal-termfilechooser.service
systemctl --user restart xdg-desktop-portal.service

echo "Done. termfilechooser portal is active."
