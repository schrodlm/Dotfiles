{
  description = "schrodlm's home-manager configuration";

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
      };

      pkgsUnfree = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
          "obsidian"
          "discord"
          "vscode"
          "spotify"
        ];
      };

      baseModules = [{
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

          # Languages
          go

          # Launchers
          rofi
        ];

        programs.home-manager.enable = true;
      }];

      appPackages = with pkgsUnfree; [
        obsidian
        discord
        vscode
        spotify
      ];
    in {
    homeConfigurations."schrodlm" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = baseModules;
    };

    homeConfigurations."schrodlm-full" = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsUnfree;
      modules = baseModules ++ [{
        home.packages = appPackages;
      }];
    };
  };
}
