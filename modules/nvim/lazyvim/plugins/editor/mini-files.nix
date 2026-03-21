{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.mini-files;
in
{
  options.programs.lazyvim.mini-files = {
    enable = mkEnableOption "Mini files explorer";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        {
          name = "mini.files";
          path = mini-nvim;
        }
      ];

      config = [ "editor/mini-files.lua" ];
    };
  };
}
