{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.window-picker;
in
{
  options.programs.lazyvim.window-picker = {
    enable = mkEnableOption "window picker";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        nvim-window-picker
      ];

      config = [ "ui/window-picker.lua" ];
    };
  };
}
