{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.yazi;
in
{
  options.programs.lazyvim.yazi = {
    enable = mkEnableOption "yazi explorer";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        yazi-nvim
      ];

      config = [ "editor/yazi.lua" ];
    };
  };
}
