{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim;
in
{
  config = mkIf (cfg.picker == "telescope") {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        telescope-nvim
        telescope-undo-nvim
        scope-nvim
      ];

      excludePlugins = with pkgs.vimPlugins; [
        fzf-lua
      ];

      config = [ "editor/telescope.lua" ];
    };
  };
}
