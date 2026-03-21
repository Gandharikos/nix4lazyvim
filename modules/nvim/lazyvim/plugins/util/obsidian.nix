{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.obsidian;
in
{
  options.programs.lazyvim.obsidian = {
    enable = mkEnableOption "Obsidian plugin for LazyVim";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        obsidian-nvim
      ];
      config = [ "util/obsidian.lua" ];
    };
  };
}
