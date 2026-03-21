{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.practice;
in
{
  options.programs.lazyvim.practice = {
    enable = mkEnableOption "Practice plugin";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        hardtime-nvim
        precognition-nvim
      ];

      config = [ "util/practice.lua" ];
    };
  };
}
