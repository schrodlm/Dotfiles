#!/bin/bash
# Bootstrap script for a fresh Debian machine.
# Safe to re-run: every step is guarded so existing state is preserved.

set -euo pipefail

# --- System packages (apt) ---
# apt install -y is already idempotent (skips installed packages).
sudo apt update
sudo apt install -y git tmux zsh i3wm i3blocks curl stow

# --- Nix package manager ---
if [ ! -e /nix ]; then
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
nix run home-manager -- switch --flake ~/Dotfiles

# --- One-time clones ---
mkdir -p ~/Apps

clone_if_missing() {
    local repo="$1" dest="$2"
    shift 2
    if [ -d "$dest/.git" ]; then
        return
    fi
    if [ -d "$dest" ]; then
        echo "warn: $dest exists but is not a git repo, skipping clone" >&2
        return
    fi
    git clone "$@" "$repo" "$dest"
}

clone_if_missing https://github.com/Coffelius/rofi-code.git ~/Apps/rofi-code
clone_if_missing https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# --- Oh-my-zsh + plugins ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    # RUNZSH=no  — don't launch an interactive zsh at the end of the installer.
    # KEEP_ZSHRC=yes — leave an existing ~/.zshrc alone (we manage it via stow).
    # CHSH=no    — don't prompt for password to change the login shell.
    RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone_if_missing https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k" --depth=1
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# --- VS Code ---
# Installed via apt instead of Nix because on a non-NixOS distro there is no
# straightforward way to bridge host GPU drivers to a Nix-installed Electron app.
# nixGL is the standard tool for this but adds friction; apt-installed Code just works.
if ! command -v code &>/dev/null; then
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

# Restore VS Code extensions from snapshot (--force makes this idempotent).
# The `|| [ -n "$ext" ]` clause catches the last line even when the file
# has no trailing newline.
if [ -f ~/Dotfiles/vscode/extensions.txt ]; then
    while IFS= read -r ext || [ -n "$ext" ]; do
        [ -z "$ext" ] && continue
        code --install-extension "$ext" --force
    done < ~/Dotfiles/vscode/extensions.txt
fi

# --- Stow ---
# `stow --restow` re-links cleanly even if links already exist.
# It still errors on real (non-symlink) files at the target — that's
# intentional, you don't want to silently clobber hand-edited configs.
cd ~/Dotfiles && stow --restow */

# Install yazi plugins declared in yazi/.config/yazi/package.toml
# (e.g. mount.yazi — USB mount manager bound to `M` in yazi)
if command -v ya &>/dev/null; then
    ya pkg install
fi
