# Dotfiles Repository

This repository contains my personal dotfiles for my Linux setup. Configurations are managed using [GNU Stow](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/) and user-facing packages are managed declaratively with [Nix](https://nixos.org/) + [home-manager](https://github.com/nix-community/home-manager).

## Fresh Machine Setup

1. Clone this repository:
   ```bash
   git clone <repo-url> ~/Dotfiles
   ```

2. Run the bootstrap script (installs system packages, Nix, and home-manager):
   ```bash
   cd ~/Dotfiles && bash dependencies.sh
   ```

3. Symlink dotfiles with stow:
   ```bash
   stow nvim tmux zsh rofi i3 lazygit nix
   ```

## Package Management

User-facing packages are declared in `flake.nix` and managed by home-manager.

- **Add a package**: add it to `home.packages` in `flake.nix`, then run:
  ```bash
  home-manager switch --flake ~/Dotfiles
  ```

- **Update all packages**:
  ```bash
  nix flake update ~/Dotfiles && home-manager switch --flake ~/Dotfiles
  ```

### Packages managed by Nix (flake.nix)
neovim, fzf, fd, ripgrep, lazygit, delta, go, rofi

### Packages managed by apt (dependencies.sh)
git, tmux, zsh, i3, i3blocks, curl

## Maintenance

- **Nix garbage collection** - Nix keeps old package versions in `/nix/store`. Clean up periodically:
  ```bash
  nix-collect-garbage -d
  ```