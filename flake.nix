{
  description = "Nix home-manager module for LazyVim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      neovim-nightly-overlay,
      ...
    }:
    let
      configRoot = self + "/config/.";

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

        sourceLua =
          path:
          let
            name = builtins.baseNameOf path;
            key = "nvim/lua/plugins/${name}";
          in
          {
            "${key}".source = lib.path.append configRoot "nvim/lua/plugins/extras/${path}";
          };
      };
    in
    {
      # Re-export neovim-nightly overlay so consumers can apply it to nixpkgs
      overlays.neovim-nightly = neovim-nightly-overlay.overlays.default;

      # Home-manager module — import this in your home-manager configuration
      homeManagerModules.default =
        { lib, ... }:
        {
          imports = [ ./modules/nvim ];
          # Provide utilities under a dedicated namespace to avoid conflicts
          # with the host's lib.my (e.g. when used inside a dotfiles repo)
          _module.args.nix4lazyvimLib = nix4lazyvimLib lib;
        };
    };
}
