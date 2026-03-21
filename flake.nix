{
  description = "Nix home-manager module for LazyVim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
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
    in
    {
      # Home-manager module — import this in your home-manager configuration
      homeManagerModules.default =
        { lib, ... }:
        {
          imports = [ ./nix ];
          # Provide utilities under a dedicated namespace to avoid conflicts
          # with the host's lib.my (e.g. when used inside a dotfiles repo)
          _module.args.nix4lazyvimLib = nix4lazyvimLib lib;
        };
    };
}
