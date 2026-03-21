{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  cfg = config.programs.lazyvim.util.octo;
in
{
  options.programs.lazyvim.util.octo = {
    enable = mkEnableOption "octo";
  };

  config = mkIf cfg.enable {
    programs.lazyvim = {
      extraPlugins = with pkgs.vimPlugins; [
        octo-nvim
      ];

      imports = [ "lazyvim.plugins.extras.util.octo" ];
    };
  };
}
