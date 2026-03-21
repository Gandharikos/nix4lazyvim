{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.mini-surround;
in
{
  options.programs.lazyvim.mini-surround = {
    enable = mkEnableOption "Fast and feature-rich surround actions";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        {
          name = "mini.surround";
          path = mini-nvim;
        }
      ];

      config = [ "coding/mini-surround.lua" ];
    };
  };
}
