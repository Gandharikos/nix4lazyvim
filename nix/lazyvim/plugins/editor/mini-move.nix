{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.editor.mini-move;
in
{
  options.programs.lazyvim.editor.mini-move = {
    enable = mkEnableOption "Mini move";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        {
          name = "mini.move";
          path = mini-nvim;
        }
      ];

      config = [ "editor/mini-move.lua" ];
    };
  };
}
