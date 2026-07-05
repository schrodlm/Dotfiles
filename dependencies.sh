#!/bin/bash
# Bootstrap script for a fresh Debian machine.
# Safe to re-run: every step is guarded so existing state is preserved.

set -euo pipefail

# Running as root would put oh-my-zsh, ~/Apps, ~/Dotfiles etc. under /root
# and wire Nix to the wrong user. Bail out early.
if [ "$EUID" -eq 0 ]; then
    echo "FATAL: do not run as root. Run as your normal user; the script will sudo when needed." >&2
    exit 1
fi

# --- System packages (apt) ---
# apt install -y is already idempotent (skips installed packages).
sudo apt update
sudo apt install -y \
    git tmux zsh curl stow \
    i3 i3blocks \
    sway swaybg swayidle swaylock waybar foot foot-terminfo \
    grim slurp wl-clipboard \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
    mako-notifier \
    playerctl brightnessctl pavucontrol \
    fonts-jetbrains-mono \
    flatpak

# --- Nix package manager ---
# Check for the nix binary rather than just /nix — the directory can exist
# from a previously interrupted install while the daemon/profile is missing.
if ! [ -x /nix/var/nix/profiles/default/bin/nix ]; then
    sh <(curl -L https://nixos.org/nix/install) --daemon
fi

# Source nix in current shell (no-op if already sourced). The daemon script
# touches some variables that may be unset, so disable `nounset` around it.
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    set +u
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    set -u
fi

# --- Home-manager (idempotent: `switch` is the canonical way to re-apply) ---
# `-b backup` lets HM rename conflicting files (e.g. ones stow placed earlier)
# to *.backup instead of aborting the whole run.
nix run home-manager -- switch --flake ~/Dotfiles#schrodlm -b backup

# --- One-time clones ---
mkdir -p ~/Apps

# clone_if_missing REPO DEST REF [extra git clone args...]
# REF (commit SHA or tag) is pinned so re-installs years later get identical code.
# If the destination exists but isn't a valid git repo (e.g. an interrupted
# previous clone), warn and skip instead of clobbering.
clone_if_missing() {
    local repo="$1" dest="$2" ref="$3"
    shift 3
    if [ -d "$dest/.git" ] && git -C "$dest" rev-parse HEAD >/dev/null 2>&1; then
        # Already a healthy clone. Check it's at the pinned ref; warn if not.
        local current
        current=$(git -C "$dest" rev-parse HEAD)
        if [ "$current" != "$ref" ] && ! git -C "$dest" merge-base --is-ancestor "$ref" HEAD 2>/dev/null; then
            echo "warn: $dest is at $current, pinned ref is $ref (run \`git -C $dest fetch && git -C $dest checkout $ref\` to update)" >&2
        fi
        return
    fi
    if [ -d "$dest" ]; then
        echo "warn: $dest exists but is not a valid git repo, skipping clone" >&2
        return
    fi
    # Clone into a tmp dir and rename on success so a network failure mid-clone
    # doesn't leave a half-`.git` that future runs would skip over.
    local tmp
    tmp=$(mktemp -d -p "$(dirname "$dest")" ".clone-XXXXXX")
    if git clone "$@" "$repo" "$tmp"; then
        git -C "$tmp" checkout --detach "$ref"
        mv "$tmp" "$dest"
    else
        rm -rf "$tmp"
        return 1
    fi
}

# Pinned to specific commits/tags so a fresh install years from now reproduces
# bit-for-bit. Bump these manually after verifying the new ref works.
clone_if_missing https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
    v3.1.0

# rofi-vscode-picker: small Python script that replaces the unmaintained
# Coffelius/rofi-code (broken on rofi 2.0). Cloned into ~/dev and symlinked
# into ~/.local/bin so sway's $mod+Shift+d binding finds it.
mkdir -p ~/dev ~/.local/bin
clone_if_missing https://github.com/schrodlm/rofi-vscode-picker.git \
    ~/dev/rofi-vscode-picker \
    97c09adc498bc46e840fa96b013696a61bde2bc5
ln -sf ~/dev/rofi-vscode-picker/rofi-vscode-picker ~/.local/bin/rofi-vscode-picker

# --- Oh-my-zsh + plugins ---
# Check the installer's marker file rather than the directory: a partial
# install can leave the dir behind without oh-my-zsh.sh.
# The install script URL is pinned to a SHA so GitHub serves immutable bytes.
OMZ_INSTALL_SHA="cb64103161b69d59e1efefeb761ac85564c44698"
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    # RUNZSH=no  — don't launch an interactive zsh at the end of the installer.
    # KEEP_ZSHRC=yes — leave an existing ~/.zshrc alone (we manage it via stow).
    # CHSH=no    — don't prompt for password to change the login shell.
    RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
        sh -c "$(curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/${OMZ_INSTALL_SHA}/tools/install.sh")"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone_if_missing https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k" \
    604f19a9eaa18e76db2e60b8d446d5f879065f90
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" \
    1d85c692615a25fe2293bdd44b34c217d5d2bf04

# --- VS Code ---
# Installed via apt instead of Nix because on a non-NixOS distro there is no
# straightforward way to bridge host GPU drivers to a Nix-installed Electron app.
# nixGL is the standard tool for this but adds friction; apt-installed Code just works.
# Use dpkg, not `command -v`: a snap- or flatpak-installed `code` would be
# on PATH but wouldn't mean the apt package + repo are set up.
if ! dpkg -s code &>/dev/null; then
    if [ ! -f /usr/share/keyrings/packages.microsoft.gpg ]; then
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
            | sudo gpg --dearmor -o /usr/share/keyrings/packages.microsoft.gpg
    fi
    if [ ! -f /etc/apt/sources.list.d/vscode.list ]; then
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
            | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
        sudo apt update
    fi
    sudo apt install -y code
fi

# Restore VS Code extensions from snapshot. Lines are `publisher.name@version`
# so installs reproduce exactly across machines. `--force` overwrites if a
# different version is on disk. A single bad extension shouldn't abort the
# bootstrap, hence the `|| echo warn`.
# The `|| [ -n "$ext" ]` clause catches the last line even when the file
# has no trailing newline.
if [ -f ~/Dotfiles/vscode/extensions.txt ]; then
    while IFS= read -r ext || [ -n "$ext" ]; do
        ext="${ext%$'\r'}"  # strip CR if the file got CRLF'd
        [ -z "$ext" ] && continue
        [[ "$ext" == \#* ]] && continue
        code --install-extension "$ext" --force \
            || echo "warn: failed to install '$ext'" >&2
    done < ~/Dotfiles/vscode/extensions.txt
fi

# --- Obsidian (Flatpak) ---
# Same Electron-on-non-NixOS problem as VS Code: a Nix-built Obsidian expects
# /run/opengl-driver/ and dies with MESA-LOADER errors on Debian. Flatpak ships
# its own GL stack via freedesktop runtime extensions, sidestepping the issue.
# `--user` keeps it out of /var and avoids needing root for app updates.
if ! flatpak info --user md.obsidian.Obsidian &>/dev/null; then
    flatpak remote-add --user --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo
    flatpak install -y --user flathub md.obsidian.Obsidian
fi

# --- Stow ---
# `stow --restow` re-links cleanly even if links already exist.
# It still errors on real (non-symlink) files at the target — that's
# intentional, you don't want to silently clobber hand-edited configs.
#
# Listed explicitly (not `*/`) because the repo root contains non-package
# directories (profiles/, scripts/) and stowing vscode/ as a whole would
# also symlink ~/extensions.txt — which lives at the package root, not
# inside .config.
STOW_PACKAGES=(
    environment.d
    foot
    gitconfig
    i3
    lazygit
    nix
    nvim
    rofi
    sway
    sway-session
    swayidle
    swaylock
    tmux
    vscode
    waybar
    xdg-desktop-portal
    yazi
    zshrc
    zshrc-p10k
)
cd ~/Dotfiles && stow --restow "${STOW_PACKAGES[@]}"

# Install yazi plugins declared in yazi/.config/yazi/package.toml
# (e.g. mount.yazi — USB mount manager bound to `M` in yazi)
# `hash -r` flushes the shell's command cache so a freshly-installed `ya`
# from home-manager is visible to `command -v` on a first run.
hash -r
if command -v ya &>/dev/null; then
    ya pkg install
fi
