# Example configuration for a dotfiles checkout at ~/.dotfiles/config/nvim
# In Nix, map the shell path via config.home.homeDirectory and builtins.path.

{ config, pkgs, ... }:

let
  dotfilesConfig = builtins.path {
    path = "${config.home.homeDirectory}/.dotfiles/config/nvim";
    name = "dotfiles-nvim-config";
  };
in
{
  programs.lazyvim = {
    enable = true;
    configDir = dotfilesConfig;

    extras = {
      lang.nix.enable = true;
      lang.lua.enable = true;
      editor.telescope.enable = true;
      editor.neo-tree.enable = true;
    };

    extraPackages = with pkgs; [
      nil
      lua-language-server
      nixfmt-rfc-style
      stylua
    ];
  };
}
