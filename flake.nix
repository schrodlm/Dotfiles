{
  description = "schrodlm home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "discord"
          "spotify"
        ];
      };
    in {
    homeConfigurations."schrodlm" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [{
        home.username = "schrodlm";
        home.homeDirectory = "/home/schrodlm";
        home.stateVersion = "24.05";

        home.packages = with pkgs; [
          # Editors
          neovim

          # CLI tools
          bat
          fzf
          fd
          ripgrep
          lazygit
          delta
          yazi
          zoxide

          # Languages
          go

          # Linters run by githooks/pre-commit
          shellcheck
          stylua
          ruff

          # Launchers
          rofi

          # Fonts — needed for waybar glyphs and the swaylock indicator font
          nerd-fonts.jetbrains-mono
          # foot.ini requests SauceCodePro Nerd Font Mono
          nerd-fonts.sauce-code-pro

          # Apps (unfree)
          # Obsidian is installed via Flatpak (md.obsidian.Obsidian), not Nix:
          # Nix-packaged Electron apps expect /run/opengl-driver/ (NixOS-only)
          # and fail to load GL on Debian without nixGL. Same rationale as VS
          # Code being apt-installed — see dependencies.sh.
          discord
          spotify

          # Electronics
          kicad
        ];

        # Without this, fonts from home.packages never reach the host
        # fontconfig on non-NixOS systems and apps silently fall back
        fonts.fontconfig.enable = true;

        programs.home-manager.enable = true;
      }];
    };
  };
}
