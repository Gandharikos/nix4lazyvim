{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.edgy;
in
{
  options.programs.lazyvim.edgy = {
    enable = mkEnableOption "edgy";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        edgy-nvim
      ];

      imports = [ "lazyvim.plugins.extras.ui.edgy" ];
    };
  };
}
