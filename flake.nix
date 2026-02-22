{
  description = "schrodlm's home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations."schrodlm" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [{
        home.username = "schrodlm";
        home.homeDirectory = "/home/schrodlm";
        home.stateVersion = "24.05";

        home.packages = with nixpkgs.legacyPackages.x86_64-linux; [
          # Editors
          neovim

          # CLI tools
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
    };
  };
}
