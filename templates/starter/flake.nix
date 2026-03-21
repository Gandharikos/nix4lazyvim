{
  description = "LazyVim home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix4lazyvim = {
      url = "github:YOUR_GITHUB/nix4lazyvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix4lazyvim,
      ...
    }:
    {
      homeConfigurations."user@hostname" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          nix4lazyvim.homeManagerModules.default
          {
            programs.lazyvim = {
              enable = true;

              # Optionally override the neovim package (e.g. nightly):
              # neovim = inputs.neovim-nightly-overlay.packages.x86_64-linux.default;

              # Pin plugin versions with lazy-lock.json:
              # lazy-lock = builtins.readFile ./lazy-lock.json;

              # Enable language support
              lang.nix.enable = true;
              lang.rust.enable = true;
              lang.go.enable = true;
              lang.typescript.enable = true;

              # Enable extras
              coding.yanky.enable = true;
              editor.mini-files.enable = true;
              ui.edgy.enable = true;
            };

            home.username = "user";
            home.homeDirectory = "/home/user";
            home.stateVersion = "24.11";
          }
        ];
      };
    };
}
