#!/bin/bash

PACKAGES=(
  "fzf"
  "ripgrep"
  "tmux"
  "zsh"
  "curl"
)

echo "Starting package installation..."

# Check for apt (Debian/Ubuntu)
if command -v apt &> /dev/null; then
  echo "Detected Debian/Ubuntu based system. Using apt."
  sudo apt update
  sudo apt install -y "${PACKAGES[@]}"

# Check for dnf (Fedora/CentOS)
elif command -v dnf &> /dev/null; then
  echo "Detected Fedora/CentOS based system. Using dnf."
  sudo dnf install -y "${PACKAGES[@]}"

# Check for pacman (Arch Linux)
elif command -v pacman &> /dev/null; then
  echo "Detected Arch based system. Using pacman."
  # The --noconfirm flag skips confirmation prompts
  sudo pacman -Syu --noconfirm "${PACKAGES[@]}"

else
  echo "Could not detect a supported package manager (apt, dnf, pacman). Please install dependencies manually."
  exit 1
fi

echo "All packages installed successfully! ✨"

# Build neovim from source

#Configure terminal
#1. Install a package manger for ZSH (oh-my-zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#2. Install used plugins 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

