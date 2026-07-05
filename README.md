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

## Yazi plugins

Plugins are declared in `yazi/.config/yazi/package.toml` (version-pinned) and the source is **not** checked in. `dependencies.sh` runs `ya pkg install` automatically on a fresh setup, but if you add a plugin later, install it with:

```bash
ya pkg install          # fetch any plugin listed in package.toml
ya pkg upgrade          # update pinned revisions
```

## Package Management

User-facing packages are declared in `flake.nix` and managed by home-manager under a single `schrodlm` configuration.

```bash
home-manager switch --flake ~/Dotfiles#schrodlm
```

### Add a package

Add it to `home.packages` in `flake.nix`, then switch.

### Update all packages

```bash
nix flake update ~/Dotfiles && home-manager switch --flake ~/Dotfiles#schrodlm
```

### Electron apps (VS Code, Obsidian)

These are deliberately **not** installed via Nix. Nix-packaged Electron apps expect `/run/opengl-driver/` (NixOS-only) and fail to load GL on Debian with `MESA-LOADER` errors. `dependencies.sh` installs:

- VS Code via apt (Microsoft's repo)
- Obsidian via Flatpak (`md.obsidian.Obsidian` from Flathub, user scope)

## Maintenance

- **Nix garbage collection** - Nix keeps old package versions in `/nix/store`. Clean up periodically:
  ```bash
  nix-collect-garbage -d
  ```