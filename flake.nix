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
          "obsidian"
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
          obsidian
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
