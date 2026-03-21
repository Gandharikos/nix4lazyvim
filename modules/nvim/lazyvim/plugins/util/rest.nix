{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.rest;
in
{
  options.programs.lazyvim.rest = {
    enable = mkEnableOption "rest tool";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        kulala-nvim
      ];

      imports = [ "lazyvim.plugins.extras.util.rest" ];
    };
  };
}
