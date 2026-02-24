#!/bin/bash
# Bootstrap script for a fresh Debian machine
# Run once to set up the base system, then home-manager handles the rest

set -e

# --- System packages (apt) ---
sudo apt update
sudo apt install -y git tmux zsh i3wm i3blocks curl stow

# --- Install Nix package manager ---
sh <(curl -L https://nixos.org/nix/install) --daemon

# Source nix in current shell
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# --- Install all user packages via home-manager flake ---
# Packages managed by flake.nix: neovim, fzf, fd, ripgrep, lazygit, delta, go, rofi
nix run home-manager -- switch --flake ~/Dotfiles

# --- One-time setup (clones, plugins) ---
mkdir -p ~/Apps
git clone https://github.com/Coffelius/rofi-code.git ~/Apps/rofi-code

# Tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Oh-my-zsh + plugins
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# --- VS Code ---
# Installed via apt instead of Nix because on a non-NixOS distro there is no
# straightforward way to bridge host GPU drivers to a Nix-installed Electron app.
# nixGL is the standard tool for this but adds friction; apt-installed Code just works.
if ! command -v code &>/dev/null; then
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
  sudo apt update
  sudo apt install -y code
fi

# Restore VS Code extensions from snapshot
if [ -f ~/Dotfiles/vscode/extensions.txt ]; then
  while read -r ext; do
    code --install-extension "$ext" --force
  done < ~/Dotfiles/vscode/extensions.txt
fi

# Apply stow (symlink configs from this repository)
cd ~/Dotfiles && stow */
