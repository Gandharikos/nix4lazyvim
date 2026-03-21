{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.startuptime;
in
{
  options.programs.lazyvim.startuptime = {
    enable = mkEnableOption "startuptime";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        startuptime-nvim
      ];

      imports = [ "lazyvim.plugins.extras.util.startuptime" ];
    };
  };
}
