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

          # Launchers
          rofi

          # Fonts — needed for waybar glyphs and the swaylock indicator font
          nerd-fonts.jetbrains-mono

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

        programs.home-manager.enable = true;
      }];
    };
  };
}
