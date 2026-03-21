{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.smear-cursor;
in
{
  options.programs.lazyvim.smear-cursor = {
    enable = mkEnableOption "animate cursor";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        smear-cursor-nvim
      ];

      imports = [ "lazyvim.plugins.extras.ui.smear-cursor" ];
    };
  };
}
