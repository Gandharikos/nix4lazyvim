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
  config = mkIf (cfg.picker == "fzf") {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        fzf-lua
      ];
      excludePlugins = with pkgs.vimPlugins; [
        telescope-nvim
      ];
      imports = [ "lazyvim.plugins.editor.fzf" ];
    };
  };
}
