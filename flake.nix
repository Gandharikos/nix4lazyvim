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
      in
      {
        # Run a minimal LazyVim: nix run github:…
        packages.default = pkgs.callPackage ./nix/package.nix {
          inherit lazyvim-starter;
        };

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
          name = "nvim";
        };
      }
    )
    // {
      # Home-manager module — import in your home-manager configuration
      homeModules.default = { imports = [ ./nix ]; };
      # Alias for backward compatibility
      homeManagerModules.default = self.homeModules.default;
    };
}
