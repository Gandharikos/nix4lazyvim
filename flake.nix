{
  description = "Nix home-manager module for LazyVim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    lazyvim-starter = {
      url = "github:LazyVim/starter";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      lazyvim-starter,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        package = pkgs.callPackage ./nix/package.nix {
          inherit lazyvim-starter;
        };
      in
      {
        # Run a minimal LazyVim: nix run github:…
        packages.default = package;

        apps.default =
          flake-utils.lib.mkApp {
            drv = package;
            name = "nvim";
          }
          // {
            meta = package.meta;
          };
      }
    )
    // {
      # Home-manager module — import in your home-manager configuration
      homeModules.default = { imports = [ ./nix ]; };
    };
}
