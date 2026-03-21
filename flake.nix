{
  description = "Nix home-manager module for LazyVim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      flake-utils,
      ...
    }:
    let
      # nix4lazyvimLib is passed to all modules via _module.args.
      # Using a dedicated namespace avoids conflicts with the host's lib.my.
      nix4lazyvimLib = lib: {
        scanPaths =
          path:
          builtins.map (f: (path + "/${f}")) (
            builtins.attrNames (
              lib.attrsets.filterAttrs (
                name: _type:
                (_type == "directory" && builtins.pathExists (path + "/${name}/default.nix"))
                || (
                  (name != "default.nix")
                  && (lib.strings.hasSuffix ".nix" name)
                )
              ) (builtins.readDir path)
            )
          );
      };

      # Home-manager module — import this in your home-manager configuration
      homeManagerModule =
        { lib, ... }:
        {
          imports = [ ./nix ];
          # Provide utilities under a dedicated namespace to avoid conflicts
          # with the host's lib.my (e.g. when used inside a dotfiles repo)
          _module.args.nix4lazyvimLib = nix4lazyvimLib lib;
        };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Minimal LazyVim starter evaluated through home-manager for the packages output
        starterConfig = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            homeManagerModule
            {
              programs.lazyvim.enable = true;
              home.username = "user";
              home.homeDirectory = "/home/user";
              home.stateVersion = "24.11";
            }
          ];
        };
      in
      {
        # Run a minimal LazyVim directly: nix run github:…
        packages.default = starterConfig.config.programs.neovim.finalPackage;
      }
    )
    // {
      homeManagerModules.default = homeManagerModule;

      templates.default = {
        path = ./templates/starter;
        description = "Minimal home-manager configuration using nix4lazyvim";
      };
    };
}
